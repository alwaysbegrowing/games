// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Attention {

    address public player1;
    address public player2;
    uint256 public player1LastCall;
    uint256 public player2LastCall;

    event AttentionAsserted(address indexed alerter, uint256 indexed timestamp);
    event PlayersSet(address indexed player1, address indexed player2);
    event Received(address, uint);

    modifier isPlayer() {
        require(msg.sender == player1 || msg.sender == player2, "Caller is not a player");
        _;
    }

    constructor(address _player1, address _player2) payable {
        player1 = _player1;
        player2 = _player2;
        player1LastCall = block.timestamp;
        player2LastCall = block.timestamp;
        emit PlayersSet(_player1, _player2);
    }

    function sendViaCall(address payable _to) public payable {
        (bool sent,) = _to.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function attemptWithdraw() public isPlayer {
    uint day = 24 * 60 * 1000;
    if (msg.sender == player1) {
            player1LastCall = block.timestamp;
        if ((block.timestamp - player2LastCall) > day) {
                 sendViaCall(payable(msg.sender));
        }
    }

     if (msg.sender == player2) {
        player2LastCall = block.timestamp;
           if ((block.timestamp - player1LastCall) > day) {
                 sendViaCall(payable(msg.sender));
        }
    }
    }

    function balance() public view returns (uint256) {
    return address(this).balance;
}

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
} 
