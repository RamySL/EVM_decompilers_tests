    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    abstract contract EIP20Interface {
        /// total amount of tokens
        uint256 public totalSupply; // slot 0


        function balanceOf(address _owner) public view virtual returns (uint256 balance);

        function transfer(address _to, uint256 _value) public virtual returns (bool success);


        function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);


        function approve(address _spender, uint256 _value) public virtual returns (bool success);


        function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);

        event Transfer(address indexed _from, address indexed _to, uint256 _value);
        event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    }

    contract EIP20 is EIP20Interface {
        uint256 private constant MAX_UINT256 = type(uint256).max;
        mapping(address => uint256) public balances;
        mapping(address => mapping(address => uint256)) public allowed;

        // Optional metadata
        string public name;
        uint8 public decimals;
        string public symbol;

        constructor(
            uint256 _initialAmount,
            string memory _tokenName,
            uint8 _decimalUnits,
            string memory _tokenSymbol
        ) {
            balances[msg.sender] = _initialAmount;
            totalSupply = _initialAmount;
            name = _tokenName;
            decimals = _decimalUnits;
            symbol = _tokenSymbol;
        }

        function transfer(address _to, uint256 _value) public override returns (bool success) {
            require(balances[msg.sender] >= _value, "Insufficient balance");
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }

        function transferFrom(
            address _from,
            address _to,
            uint256 _value
        ) public override returns (bool success) {
            uint256 allowedAmount = allowed[_from][msg.sender];
            require(balances[_from] >= _value && allowedAmount >= _value, "Insufficient balance or allowance");
            balances[_to] += _value;
            balances[_from] -= _value;
            if (allowedAmount < MAX_UINT256) {
                allowed[_from][msg.sender] = allowedAmount - _value;
            }
            emit Transfer(_from, _to, _value);
            return true;
        }

        function balanceOf(address _owner) public view override returns (uint256 balance) {
            return balances[_owner];
        }

        function approve(address _spender, uint256 _value) public override returns (bool success) {
            allowed[msg.sender][_spender] = _value;
            emit Approval(msg.sender, _spender, _value);
            return true;
        }

        function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
            return allowed[_owner][_spender];
        }
    }

