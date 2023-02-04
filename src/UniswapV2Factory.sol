pragma solidity ^0.8.13;

import './interfaces/IUniswapV2Factory.sol';
import './UniswapV2Pair.sol';

contract UniswapV2Factory is IUniswapV2Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    // event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter)  {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES'); // los tokens deben ser distintos
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); // @audit porque se ordenan??
        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS'); // requiere q sea != 0
        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // requiere q el par no exista
        bytes memory bytecode = type(UniswapV2Pair).creationCode;/// @audit enteder este tipo de creacion
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }///
        IUniswapV2Pair(pair).initialize(token0, token1);// inicializa con las variables
        getPair[token0][token1] = pair;// guarda el par
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);// guarda el par
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}