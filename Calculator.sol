// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "./Stack.sol";

/* My Reference Code in JavaScript

const getPriority = (operator, inStack) => {
    if (operator === '+' || operator === '-') {
        return 1;
    } else if (operator === '*' || operator === '/') {
        return 2;
    } else if (operator === '(') {
        if (inStack) return 0;
        else return 5;
    } else if (operator === ')') {
        return 4;
    }
};

const infixToPostfix = (infix) => {
    const operators = ['(', ')', '+', '-', '*', '/'];
    const stack = [];
    const postfix = [];

    infix = infix.split(' ');
    infix.forEach((token) => {
        if (operators.includes(token)) {
            if (token === ')') {
                // 토큰이 ')' 연산자인 경우, '('를 만날 때까지 Postfix에 삽입
                let popped = stack.pop();
                while (popped !== '(') {
                    postfix.push(popped);
                    popped = stack.pop();
                }
            } else {
                if (stack.length === 0) {
                    stack.push(token);
                } else {
                    // 최상위 노드와 토큰의 연산자 우선순위 비교
                    // 이 과정이 없으면 '1 - 3 * 2'의 후위 표현식이 '1 3 - 2 *'가 됨
                    let popped = stack.pop();
                    if (getPriority(popped, true) > getPriority(token, false)) {
                        postfix.push(popped);
                    } else {
                        stack.push(popped);
                    }
                    stack.push(token);
                }
            }
        } else {
            // 토큰이 피연산자인 경우 Postfix에 삽입
            postfix.push(token);
        }
    });

    // 스택의 남은 노드(연산자)를 모두 후위에 붙임
    while (stack.length !== 0) {
        postfix.push(stack.pop());
    }

    return postfix.join(' ');
};

const calculate = (postfix) => {
    const operators = ['+', '-', '*', '/'];
    const stack = [];

    postfix.split(' ').forEach((token) => {
        if (operators.includes(token)) {
            let operand1 = parseFloat(stack.pop());
            let operand2 = parseFloat(stack.pop());
            let temp;

            if (token === '+') temp = operand2 + operand1;
            else if (token === '-') temp = operand2 - operand1;
            else if (token === '*') temp = operand2 * operand1;
            else if (token === '/') temp = operand2 / operand1;

            stack.push(temp);
        } else {
            stack.push(token);
        }
    });

    return stack[0];
};
input = '( 3 + 5 * ( 4 - 6 ) / 2 )';
console.log('input : ', input);
post = infixToPostfix(input);
console.log('postfix : ', post);
result = calculate(post);
console.log('result : ', result);


*/

contract Calculator { 

    using StackLibrary for StackLibrary.Stack;
    StackLibrary.Stack  stack;
    
    function isOperator(string memory charactor) public pure returns (bool isOperator) {
        if (_compare(charactor,unicode"+") || _compare(charactor,unicode"-") || _compare(charactor,unicode"*") || _compare(charactor,unicode"/") || _compare(charactor,unicode"(") || _compare(charactor,unicode")"))
            return true;
        else return false;
    }

    function getPriority(string memory operator, bool inStack) public pure returns (uint256 priority) {
        // if '+'
        if (_compare(operator,unicode"+")) {
            priority = 1;
        // if '*' or '/'
        } else if (_compare(operator,unicode"*") || _compare(operator,unicode"/")) {
            priority = 2;
        // if '('
        } else if (_compare(operator,unicode"(")) {
            if (inStack) priority = 0;
            else priority = 5;
        // if ')' 
        } else if (_compare(operator,unicode")")) {
            priority = 5;
        } else {
            revert("cannot reached here");
        }
    }

    function infixToPostfix(string[] memory infixTokens) public returns (string[] memory postfix) {
        string[] memory postfix = new string[](infixTokens.length);
        
        for (uint256 i = 0; i < infixTokens.length; i++) {
            if (isOperator(infixTokens[i])) {
                    if (_compare(operator,unicode")")) {

                    } else {
                        
                    }
            } else {
                postfix[i] = infixTokens[i];
            }
        }
   
   
        stack.pop();
        stack.clearAll();  
    }

    function isEqual(string memory i) public view returns (bool) {
        return _compare(i,unicode"\u002B");
    }

    function _compare(string memory str1, string memory str2) internal pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
 
    function test() external view returns (uint256) {
        return 123;
    }
}