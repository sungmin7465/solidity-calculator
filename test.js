const getPriority = (operator, inStack) => {
  if (operator === "+" || operator === "-") {
    return 1;
  } else if (operator === "*" || operator === "/") {
    return 2;
  } else if (operator === "(") {
    if (inStack) return 0;
    else return 5;
  } else if (operator === ")") {
    return 4;
  }
};
const infixToPostfix = (infix) => {
  const operators = ["(", ")", "+", "-", "*", "/"];
  const stack = [];
  const postfix = [];
  infix = infix.split(" ");
  infix.forEach((token) => {
    if (operators.includes(token)) {
      if (token === ")") {
        // 토큰이 ')' 연산자인 경우, '('를 만날 때까지 Postfix에 삽입
        let popped = stack.pop();
        while (popped !== "(") {
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
  return postfix.join(" ");
};
const calculate = (postfix) => {
  const operators = ["+", "-", "*", "/"];
  const stack = [];
  postfix.split(" ").forEach((token) => {
    if (operators.includes(token)) {
      let operand1 = parseFloat(stack.pop());
      let operand2 = parseFloat(stack.pop());
      let temp;
      if (token === "+") temp = operand2 + operand1;
      else if (token === "-") temp = operand2 - operand1;
      else if (token === "*") temp = operand2 * operand1;
      else if (token === "/") temp = operand2 / operand1;
      stack.push(temp);
    } else {
      stack.push(token);
    }
  });
  return stack[0];
};
input = "( 3 + 5 * ( 4 - 6 ) / 2 )";
console.log("input : ", input);
post = infixToPostfix(input);
console.log("postfix : ", post);
result = calculate(post);
console.log("result : ", result);
