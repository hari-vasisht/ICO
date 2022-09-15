// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ICryptoDream.sol";

contract CryptoDreamToken is ERC20, Ownable {
    uint public constant tokenPrice = 0.01 ether;
    uint public constant tokensPerNFT = 10 * 10**18;
    uint public constant maxTotalSupply = 10000 * 10**18;
    mapping(uint => bool) public tokenIdsClaimed;
    ICryptoDream CryptoDreamNFT;

    constructor(address _cryptoDreamContract)
        ERC20("Crypto Dream Token", "CDr")
    {
        CryptoDreamNFT = ICryptoDream(_cryptoDreamContract);
    }

    function mint(uint amount) public payable {
        uint _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is not sufficient");
        uint amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the maximum total supply possible"
        );
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;
        uint balance = CryptoDreamNFT.balanceOf(sender);
        require(balance > 0, "You do not own any CryptoDreamer NFT");
        uint amount = 0;
        for (uint i = 0; i < balance; i++) {
            uint tokenId = CryptoDreamNFT.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "You have claimed all the tokens");
        _mint(msg.sender, amount * tokensPerNFT);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
