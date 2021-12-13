pragma solidity >=0.7.0 <0.9.0;

contract myGame {
    uint public playerCount = 0; 
    uint public pot = 0;
    mapping(address => Player) public players;

    address public dealer;

    enum Level{
        NOVICE,
        INTERMEDIATE,
        ADVANCE
    } 

    Player[] public playersinGame;

    struct Player {
        address playerAddress;
        string firstname;
        string lastname;
        Level playerLevel;
        uint createdTime;
    }

    constructor(){
        dealer = msg.sender;  
    }

    function addPlayer(string memory firstname, string memory lastname) private{
        Player memory newPlayer = Player(msg.sender,firstname,lastname,Level.NOVICE,block.timestamp); 
        players[msg.sender] = newPlayer;
        playersinGame.push(newPlayer);
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

    function joinGame(string memory firstname, string memory lastname) payable public {
        require(msg.value == 1 ether,"The joining fees is 25 ethers");
        if(payable(dealer).send(msg.value)){
            addPlayer(firstname,lastname);
            pot+=1;
        }
    }


    function payOutWinners(address loserAddress) payable public {
        require(msg.sender == dealer);
        require(msg.value == pot * (1 ether));
        uint payoutPerWinner = pot / (playerCount -1 );
        for(uint i=0; i < playerCount -1;i++){
            address currentPlayerAddress = playersinGame[i].playerAddress;
            if(currentPlayerAddress !=loserAddress)
            {
                payable(currentPlayerAddress).transfer(payoutPerWinner);
            }
        }
    }
}

