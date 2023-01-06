// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

library StackLibrary {
    struct Stack {
        string[] elements;
    }

    function push(Stack storage self, string memory element) internal {
        self.elements.push(element);
    }

    function pop(Stack storage self) internal returns (string memory data) {
        data = self.elements[self.elements.length-1];
        self.elements.pop();
    }

    function clearAll(Stack storage self) internal {
        delete self.elements;
    }
}