pragma solidity >=0.7.0 <0.9.0;

contract myGame {
    uint public playerCount = 0;
    mapping(address => Player) public players;

    enum Level{
        NOVICE,
        INTERMEDIATE,
        ADVANCE
    } 

    struct Player {
        string firstname;
        string lastname;
        Level playerLevel;
        uint createdTime;
    }

    function addPlayer(string memory firstname, string memory lastname) public{
        players[msg.sender] = Player(firstname,lastname,Level.NOVICE,block.timestamp);
        playerCount +=1;
    }

    function getPlayerLevel(address account) public view returns(Level){
        return players[account].playerLevel;
    }

    function changePlayerLevel(address account) public {
        Player storage player = players[account];
        if(block.timestamp > player.createdTime + 20){
            player.playerLevel = Level.INTERMEDIATE;
        }
    }
}

