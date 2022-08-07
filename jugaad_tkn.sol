// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title ERC20 Contract for Jugaadu token (JGD)
/// @notice Contract created in response to the W3Dev task. 
/// @dev Contract Jugaadu is an Ownable token

import "@openzeppelin/contracts@4.7.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.2/utils/math/SafeMath.sol";

contract Jugaadu is ERC20, Ownable {
    using SafeMath for uint256; 
    /**
     * @dev Emitted when tokens are moved from one account to another
     * Used to update the listener if the concerened account has tokens
     * or not.
     * Not to be implemented in reality as this excercise is only for 
     * practice, and better methods exist to see if any account has a
     * specified token or not. Using this might only serve to drive up gas.
     */
    event HasJGD(address acc, bool acchas);   

    constructor() ERC20("Jugaadu", "JGD") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    /** @dev Modified(overrode) the transfer() function to send the contract
     * creator (address me) around 5% of all sent transactions as txn fees.
     *
     * "address me" has been hardcoded here.
     * Emits a {HasJDG} event with `from` set to the zero address.
     *
     * Please visit the OpenZeppelin ERC20 contract for a better understanding 
     * of the original transfer().
     *
     * Emits {HasJGD}, approving that the reciever (to) has JGD tokens.
     * Emits {HasJGD} to attach 'false' to the sender if the sender has no 
     * remaining JDG tokens. 
     */  
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        uint256 _paisa_sent = amount*95/100;
        uint256 _paisa_part = SafeMath.sub(amount, _paisa_sent);
        address me = 0xf02dA9ea2e525eF2eD7D3De575d7105BABB260A6;
        _transfer(owner, to, _paisa_sent);
        _transfer(owner, me, _paisa_part);
        emit HasJGD(to, true);
        if (balanceOf(owner) < 1) {
            emit HasJGD(owner, false);
        }
        return true;
    }
}
