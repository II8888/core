// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';

/**
 * @dev A simple mock currency to be used for testing.
 */
contract Currency is ERC20('Currency', 'CRNC') {
    function testCurrency() public {
        // Prevents being counted in Foundry Coverage
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
