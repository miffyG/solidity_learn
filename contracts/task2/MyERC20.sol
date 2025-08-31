// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MyERC20 {
    string public name;
    string public symbol;
    uint8  public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Errors
    error InsufficientBalance(address sender, uint256 balance, uint256 amount);
    error InvalidSender(address sender);
    error InvalidReceiver(address receiver);
    error InvalidSpender(address spender);
    error InsufficientAllowance(address spender, uint256 currentAllowance, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint256 initialSupplyTokens) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        require(initialSupplyTokens > 0, "initialSupplyTokens must be greater than zero");
        uint256 scaled = initialSupplyTokens * (10 ** uint256(decimals));
        _balances[owner] = scaled;
        totalSupply = scaled;
        emit Transfer(address(0), owner, scaled);
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        if (spender == address(0)) {
            revert InvalidSpender(spender);
        }
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        if (currentAllowance < value) {
            revert InsufficientAllowance(msg.sender, currentAllowance, value);
        }
        _allowances[from][msg.sender] = currentAllowance - value;
        emit Approval(from, msg.sender, value);

        _transfer(from, to, value);
        return true;
    }

    function mint(address to, uint256 amount) external onlyOwner returns (bool) {
        if (to == address(0)) {
            revert InvalidReceiver(to);
        }
        totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

	/**
	* @dev Internal function to transfer tokens between addresses.
	* Reverts if sender is zero address, receiver is zero address, or sender lacks sufficient balance.
	* @param from The address to deduct tokens from (must not be zero address).
	* @param to The address to credit tokens to (must not be zero address).
	* @param value The amount of tokens to transfer (in base units, e.g., wei for 18 decimals).
	* @notice Emits a {Transfer} event upon success.
	*/
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert InvalidSender(from);
        }
        if (to == address(0)) {
            revert InvalidReceiver(to);
        }
        uint256 fromBalance = _balances[from];
        if (fromBalance < value) {
            revert InsufficientBalance(from, fromBalance, value);
        }
        _balances[from] = fromBalance - value;
        _balances[to] += value;
        emit Transfer(from, to, value);
    }
}