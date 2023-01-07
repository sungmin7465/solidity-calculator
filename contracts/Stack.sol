// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

library StackLibrary {
    struct Stack {
        string[] elements;
    }

    function getElementAt(
        Stack storage self,
        uint256 i
    ) internal view returns (string memory) {
        return self.elements[i];
    }

    function length(Stack storage self) internal view returns (uint256) {
        return self.elements.length;
    }

    function push(Stack storage self, string memory element) internal {
        self.elements.push(element);
    }

    function pop(Stack storage self) internal returns (string memory data) {
        require(self.elements.length > 0, "stack length is 0.");
        data = self.elements[self.elements.length - 1];
        self.elements.pop();
    }

    function clearAll(Stack storage self) internal {
        delete self.elements;
    }
}
