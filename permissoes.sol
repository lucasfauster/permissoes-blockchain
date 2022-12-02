// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

enum accountRole {Trainee, Regular, Manager}
enum permissionLevel {Low, Medium, High}

contract Permission {

    uint public defaultDeltaTimeExpiration = 2 weeks;
    mapping(address => Employer) public Account;
    address public owner;
    event requestOwner(address requester, 
                        address destinyAccount, 
                        permissionLevel level);

    struct Employer {
        permissionLevel state;
        accountRole role;
        uint timeExpiration;
    }

    constructor(address _ower){
        Account[msg.sender] = Employer(permissionLevel.High,
                                       accountRole.Manager,
                                       block.timestamp + defaultDeltaTimeExpiration);
        owner = _ower;
    }

    function add(address account, uint role) public returns(bool) {
        if(Account[msg.sender].role == accountRole.Manager) {
            Account[account] = Employer(permissionLevel.Low ,
                accountRole(role),
                block.timestamp + defaultDeltaTimeExpiration
            );
            return true;
        }
        return false;
    }

    function setMedium(address account) public returns(bool) {
        if(Account[msg.sender].role == accountRole.Manager) {
            Account[account].state = permissionLevel.Medium;
            Account[account].timeExpiration = block.timestamp + defaultDeltaTimeExpiration;
            return true;
        }
        return false;
    }

    function isMedium(address account) public view returns(bool){
        return Account[account].state >= permissionLevel.Medium 
        && Account[account].timeExpiration > block.timestamp;
    }

    function setHigh(address account) public returns(bool) {

        if(msg.sender == owner){
            Account[account].state = permissionLevel.High;
            Account[account].timeExpiration = block.timestamp + defaultDeltaTimeExpiration;
            return true;
        }
        return false;
    }

    function isHigh(address account) public view returns(bool) {
        return Account[account].state == permissionLevel.High
            && Account[account].timeExpiration > block.timestamp;
    }

    function setLow(address account) public returns(bool) {
        if(Account[msg.sender].role == accountRole.Manager) {
            Account[account].state = permissionLevel.Low;
            Account[account].timeExpiration = block.timestamp ;
            return true;
        }
        return false;
    }
    
    function requestOwnerRole(address account) external {
        if(Account[msg.sender].role == accountRole.Manager){
            emit requestOwner(msg.sender,account,permissionLevel.High);
        }
    }
}
