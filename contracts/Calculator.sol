// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "./Stack.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";

contract Calculator {
    using StackLibrary for StackLibrary.Stack;
    StackLibrary.Stack stack;

    int256 result;

    function isOperator(
        string memory charactor
    ) public pure returns (bool isOperator) {
        if (
            _compare(charactor, unicode"+") ||
            _compare(charactor, unicode"-") ||
            _compare(charactor, unicode"*") ||
            _compare(charactor, unicode"/") ||
            _compare(charactor, unicode"(") ||
            _compare(charactor, unicode")")
        ) return true;
        else return false;
    }

    function getPriority(
        string memory operator,
        bool inStack
    ) public pure returns (int256 priority) {
        if (_compare(operator, unicode"+") || _compare(operator, unicode"-")) {
            priority = 1;
        } else if (
            _compare(operator, unicode"*") || _compare(operator, unicode"/")
        ) {
            priority = 2;
        } else if (_compare(operator, unicode"(")) {
            if (inStack) priority = 0;
            else priority = 5;
        } else if (_compare(operator, unicode")")) {
            priority = 4;
        } else {
            priority = -1;
        }
    }

    function setResult(string[] memory infixTokens) public {
        result = calculate(infixToPostfix(infixTokens));
    }

    function getResult() public view returns (int256) {
        return result;
    }

    function infixToPostfix(
        string[] memory infixTokens
    ) public returns (string[] memory postfix) {
        uint256 tokensLength = infixTokens.length;
        postfix = new string[](tokensLength);
        string memory popped;
        uint256 k;
        int256 priority1;
        int256 priority2;

        for (uint256 i = 0; i < tokensLength; i++) {
            if (isOperator(infixTokens[i])) {
                if (_compare(infixTokens[i], unicode")")) {
                    popped = stack.pop();
                    while (!_compare(popped, unicode"(")) {
                        postfix[k++] = popped;
                        popped = stack.pop();
                    }
                } else {
                    if (stack.length() == 0) {
                        stack.push(infixTokens[i]);
                    } else {
                        popped = stack.pop();

                        priority1 = getPriority(popped, true);
                        priority2 = getPriority(infixTokens[i], false);
                        if (
                            (priority1 > -1 && priority2 > -1) &&
                            (priority1 > priority2)
                        ) {
                            postfix[k++] = popped;
                        } else {
                            stack.push(popped);
                        }
                        stack.push(infixTokens[i]);
                    }
                }
            } else {
                postfix[k++] = infixTokens[i];
            }
        }

        while (stack.length() != 0) {
            postfix[k++] = stack.pop();
        }

        assembly {
            mstore(postfix, sub(mload(postfix), sub(tokensLength, k)))
        }

        stack.clearAll();
    }

    function _logStrings(string[] memory strings) internal {
        string memory result;
        for (uint256 i = 0; i < strings.length; i++) {
            result = string.concat(result, strings[i]);
        }
        console.log("_logStrings : ", result);
    }

    // TODO : int256 지원범위 확인 필요
    function calculate(
        string[] memory postfixTokens
    ) public returns (int256 result) {
        int256 operand1;
        int256 operand2;
        int256 temp;
        for (uint256 i = 0; i < postfixTokens.length; i++) {
            if (isOperator(postfixTokens[i])) {
                operand1 = parseInt(stack.pop());
                operand2 = parseInt(stack.pop());

                if (_compare(postfixTokens[i], unicode"+"))
                    temp = operand2 + operand1;
                else if (_compare(postfixTokens[i], unicode"-"))
                    temp = operand2 - operand1;
                else if (_compare(postfixTokens[i], unicode"*"))
                    temp = operand2 * operand1;
                else if (_compare(postfixTokens[i], unicode"/"))
                    temp = operand2 / operand1;
                else revert("cannot reached here");
                stack.push(toString(temp));
            } else {
                stack.push(postfixTokens[i]);
            }
        }
        result = parseInt(stack.getElementAt(0));
        stack.clearAll();
        return result;
    }

    function toString(int256 value) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    value < 0 ? "-" : "",
                    Strings.toString(SignedMath.abs(value))
                )
            );
    }

    function parseInt(
        string memory numString
    ) public pure returns (int256 val) {
        uint i = 0;
        bool flag = false;
        if (bytes8(bytes(numString)[0]) == "-") {
            i = 1;
            flag = true;
        }

        bytes memory stringBytes = bytes(numString);

        for (; i < stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
            uint jval = uval - uint(0x30);

            val += int256(jval * (10 ** (exp - 1)));
        }
        if (flag) val *= -1;
        return val;
    }

    function _compare(
        string memory str1,
        string memory str2
    ) internal pure returns (bool) {
        return
            keccak256(abi.encodePacked(str1)) ==
            keccak256(abi.encodePacked(str2));
    }
}
