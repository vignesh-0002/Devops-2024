# Types of Operators in Python with Examples

Python provides several types of operators to perform different operations on variables and values.

## 1. Arithmetic Operators (Perform mathematical operations)

| Operator | Description | Example (`a = 10, b = 3`) | Output |
|----------|------------|-------------------------|--------|
| `+` | Addition | `a + b` | `13` |
| `-` | Subtraction | `a - b` | `7` |
| `*` | Multiplication | `a * b` | `30` |
| `/` | Division | `a / b` | `3.3333` |
| `//` | Floor Division | `a // b` | `3` |
| `%` | Modulus (Remainder) | `a % b` | `1` |
| `**` | Exponentiation | `a ** b` | `1000` |

### Example Code
```python
a = 10
b = 3

print("Addition:", a + b)
print("Subtraction:", a - b)
print("Multiplication:", a * b)
print("Division:", a / b)
print("Floor Division:", a // b)
print("Modulus:", a % b)
print("Exponentiation:", a ** b)
```

## 2. Comparison Operators (Compare values, return `True` or `False`)

| Operator | Description | Example (`a = 10, b = 3`) | Output |
|----------|------------|-------------------------|--------|
| `==` | Equal to | `a == b` | `False` |
| `!=` | Not equal to | `a != b` | `True` |
| `>` | Greater than | `a > b` | `True` |
| `<` | Less than | `a < b` | `False` |
| `>=` | Greater than or equal to | `a >= b` | `True` |
| `<=` | Less than or equal to | `a <= b` | `False` |

### Example Code
```python
print("Equal to:", a == b)
print("Not equal to:", a != b)
print("Greater than:", a > b)
print("Less than:", a < b)
print("Greater than or equal to:", a >= b)
print("Less than or equal to:", a <= b)
```

## 3. Logical Operators (Combine multiple conditions)

| Operator | Description | Example (`x = True, y = False`) | Output |
|----------|------------|-------------------------|--------|
| `and` | Returns `True` if both conditions are `True` | `x and y` | `False` |
| `or` | Returns `True` if at least one condition is `True` | `x or y` | `True` |
| `not` | Reverses the condition | `not x` | `False` |

### Example Code
```python
x = True
y = False

print("AND:", x and y)
print("OR:", x or y)
print("NOT:", not x)
```

## 4. Assignment Operators (Assign values with operations)

| Operator | Example (`a = 10`) | Equivalent To | Output |
|----------|-----------------|--------------|--------|
| `=` | `a = 10` | Assigns `10` to `a` | `10` |
| `+=` | `a += 5` | `a = a + 5` | `15` |
| `-=` | `a -= 3` | `a = a - 3` | `12` |
| `*=` | `a *= 2` | `a = a * 2` | `24` |
| `/=` | `a /= 4` | `a = a / 4` | `6.0` |
| `//=` | `a //= 2` | `a = a // 2` | `3.0` |
| `%=` | `a %= 3` | `a = a % 3` | `0.0` |
| `**=` | `a **= 2` | `a = a ** 2` | `0.0` |

### Example Code
```python
a = 10
a += 5  # a = a + 5
print("After +=:", a)
```

## 5. Bitwise Operators (Work with binary numbers)

| Operator | Description | Example (`a = 5 (0101), b = 3 (0011)`) | Output |
|----------|------------|--------------------------------|--------|
| `&` | AND | `a & b` | `1 (0001)` |
| `|` | OR | `a | b` | `7 (0111)` |
| `^` | XOR | `a ^ b` | `6 (0110)` |
| `~` | NOT | `~a` | `-6` |
| `<<` | Left Shift | `a << 1` | `10 (1010)` |
| `>>` | Right Shift | `a >> 1` | `2 (0010)` |

### Example Code
```python
a = 5  # 0101 in binary
b = 3  # 0011 in binary

print("Bitwise AND:", a & b)
print("Bitwise OR:", a | b)
print("Bitwise XOR:", a ^ b)
print("Bitwise NOT:", ~a)
print("Left Shift:", a << 1)
print("Right Shift:", a >> 1)
```

## 6. Membership Operators (Check if a value exists in a sequence)

| Operator | Description | Example (`my_list = [1, 2, 3]`) | Output |
|----------|------------|-------------------------|--------|
| `in` | Returns `True` if value exists | `2 in my_list` | `True` |
| `not in` | Returns `True` if value does not exist | `5 not in my_list` | `True` |

### Example Code
```python
my_list = [1, 2, 3]

print("Is 2 in list?", 2 in my_list)
print("Is 5 not in list?", 5 not in my_list)
```

## 7. Identity Operators (Check if two variables refer to the same object)

| Operator | Description | Example (`a = 10, b = 10`) | Output |
|----------|------------|-------------------------|--------|
| `is` | Returns `True` if both refer to same object | `a is b` | `True` |
| `is not` | Returns `True` if they refer to different objects | `a is not b` | `False` |

### Example Code
```python
a = 10
b = 10

print("a is b:", a is b)
print("a is not b:", a is not b)
```

## Summary Table

| Type | Operators |
|------|----------|
| **Arithmetic** | `+`, `-`, `*`, `/`, `//`, `%`, `**` |
| **Comparison** | `==`, `!=`, `>`, `<`, `>=`, `<=` |
| **Logical** | `and`, `or`, `not` |
| **Assignment** | `=`, `+=`, `-=`, `*=`, `/=`, `//=`, `%=` |
| **Bitwise** | `&`, `|`, `^`, `~`, `<<`, `>>` |
| **Membership** | `in`, `not in` |
| **Identity** | `is`, `is not` |

## Conclusion
- Python provides different types of operators to perform calculations, compare values, manipulate bits, and check conditions.
- Understanding these operators helps in writing efficient and optimized code.

