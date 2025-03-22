def visualize_brackets(text):
    stack = []  # 括弧の位置を保持
    pairs = {}  # 対応する括弧のペア
    result = []

    # 括弧の対応を記録
    for i, char in enumerate(text):
        if char == '(':
            stack.append(i)
        elif char == ')':
            if stack:
                start = stack.pop()
                pairs[start] = i

    # 可視化用の文字列を構築
    indent = 0
    for i, char in enumerate(text):
        if char == '(':
            result.append(' ' * indent + f'{i}: (')
            indent += 2
        elif char == ')':
            indent -= 2
            result.append(' ' * indent + f'{i}: ) [← {list(pairs.keys())[list(pairs.values()).index(i)]}]')

    return '\n'.join(result)

# 入力テキスト
text = "(0+(\.0*)?|-0*1(\.0*)?|\d+(\.\d{1,3})?|((\d+:)?[0-5]\d:)?([0-5]\d|\d)(\.\d{1,3})?)"

# 対応を可視化して出力
print(visualize_brackets(text))
