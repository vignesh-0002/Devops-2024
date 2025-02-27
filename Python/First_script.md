# I am going to create my first python script.
## Basics:
### 1.Expression.
* Type 2 + 2 and then press Enter.
* In Python 2 + 2 is called an "expression".
* It's the most basic kind of programming instruction in the Python language.</br>

## Output:
![image](https://github.com/user-attachments/assets/f1c85aef-b0ac-4b2e-9950-397b7f7c9934)

* Expressions consist of values, such as the 2s, and operators, such as the +.
* Expressions always evaluate, that is they always reduce down to a single value.
* So in this example 2 + 2 is evaluated down to a single value.

* The expression 2 evaluates to itself. </br>
## Output:
![image](https://github.com/user-attachments/assets/ffd6f092-6635-41d8-a99c-f23c7382bf55)

### 2. There's several other types of operators we can try out.

Type the following: `5 - 3`, which does subtraction and evaluates `2`. 
`3 * 7`, which does multiplication and evaluates to `21`. Note that multiplication is done with the asterisk and not the` X`. If you try to type something like
`3 x 7`, Python will just give you an error.</br>
## Output:
![image](https://github.com/user-attachments/assets/c7c5a9d0-7bc8-4124-80ee-ff963447c4ca)
</br>
</br>
For division we use the `forward slash`. So `22 / 7` evaluates to `3.14`.
## Output:
![image](https://github.com/user-attachments/assets/bea5f500-8820-4d1f-8826-2326d783f07f)

* Order of operation rules apply here. Multiplication and division are done first, then addition and subtraction, but you can use parentheses to override the usual precedence if you need to, So let's look at two similar expressions: `2 + 3 * 6`, which evaluates to `20`.
## Output:
![image](https://github.com/user-attachments/assets/3fbf057f-0e13-4af2-af1c-84470e5f422d) </br>
</br>
* No matter how big the expression is Python evaluates it until it becomes a single value.
## Example:</br>
![image](https://github.com/user-attachments/assets/f6976ca0-c682-4ba8-b447-1fe0da7bd3ec)

# Built-in Data Types
In programming, data type is an important concept.
Variables can store data of different types, and different types can do different things.
Python has the following data types built-in by default, in these categories:

``` Text Type:	str
Numeric Types:	int, float, complex
Sequence Types:	list, tuple, range
Mapping Type:	dict
Set Types:	set, frozenset
Boolean Type:	bool
Binary Types:	bytes, bytearray, memoryview
None Type:	NoneType
```

# Data types with example:

Setting the Data Type
In Python, the data type is set when you assign a value to a variable:


| Example Data_Type                              | Type       |
|------------------------------------------------|------------|
| `x = "Hello World"`                            | `str`     |
| `x = 20`                                      | `int`     |
| `x = 20.5`                                    | `float`   |
| `x = 1j`                                      | `complex` |
| `x = ["apple", "banana", "cherry"]`          | `list`    |
| `x = ("apple", "banana", "cherry")`          | `tuple`   |
| `x = range(6)`                                | `range`   |
| `x = {"name" : "John", "age" : 36}`          | `dict`    |
| `x = {"apple", "banana", "cherry"}`          | `set`     |
| `x = frozenset({"apple", "banana", "cherry"})` | `frozenset` |
| `x = True`                                    | `bool`    |
| `x = b"Hello"`                                | `bytes`   |
| `x = bytearray(5)`                            | `bytearray` |
| `x = memoryview(bytes(5))`                   | `memoryview` |
| `x = None`                                    | `NoneType` |

# String concatenation 
So now we are going to look what is string concadination.</br>
When the plus operator is used on strings it's the "string concatenation" operator. 
Concatenation means, "joins the strings together". 
</br>
For example let us type: `'Vignesh' + ' Selvaraj'`
## Output:
![image](https://github.com/user-attachments/assets/f875ab24-fe00-4220-ae25-7512e3ce8707) </br>
# String replication
Now lets combine the multiplication operator for the for string replication which operates on an integer and a string.
This is handy if you have to make a string repeat itself. </br>
You can type in a string `'Vignesh' * 3` to create the string `'VigneshVigneshVignesh'`.
## Example_1:
![image](https://github.com/user-attachments/assets/8d40d024-95d7-4217-b4d4-4f803d0e3d6a)
## Example_2:
![image](https://github.com/user-attachments/assets/9e5e244c-1509-442d-b8ea-ea4912170ee3)

# Variables:
A variable is kind of like a box that can store a single value.
You can do this with an assignment statement. In the interactive shell enter `spam = 42`.
This creates a new variable named spam and stores the value `42` inside of it.</br>
![image](https://github.com/user-attachments/assets/8806afa6-9b77-4885-a9ab-c295d09166cc)

You can use variables and expressions anywhere you would normally use values. A variable just evaluates to the value it contains. So when I type spam, that evaluates to `42`. </br>
So in the interactive shell type `spam = 'Hello'`. That will store the string `'Hello'` in the variable spam. </br>
Now when we have the expression `spam + 'world'`... oh, whoops, well Python does exactly what we tell it to which is why it doesn't have a space in between these words. Let's try that again.
`spam + ' world'` with space in front.
## Output_1:
![image](https://github.com/user-attachments/assets/6f93b15a-528f-4eb2-b6cd-1c0cee7146d9)
## Output_2:
![image](https://github.com/user-attachments/assets/c7e56941-cc3c-4737-abbd-107458eaea31)
</br>
There we go. So this is just regular string concatenation because spam evaluates down to the string inside of it, and then that gets concatenated with the `' world'` string.\
### Variable overwriting.
Additional assignment statements can change the value that's inside the variable. The old value is forgotten.</br>
This is called `"overwriting"` the variable. So I could set span to a new variable.</br>
uh, value such as `'Goodbye'`.
# Example:
![image](https://github.com/user-attachments/assets/3859eeff-a633-41ed-8663-004c978c2c32)

This same `spam + ' world'` expression evaluates to a different value. So you can think of the old value as just being tossed out and forgotten and the new value being assigned every time we have an assignment statement.

![image](https://github.com/user-attachments/assets/7fa7bf5b-dc3c-43a2-b08e-d0795f9f9f22)</br>
# Statements:
`Expressions` are one kind of instruction in Python. The other kind are `statements`.
Unlike expressions, statements don't evaluate to single value.
Although an assignment statement can have an expression as part of itself.
Let's try typing `spam = 2 + 2`. The `2 + 2` expression evaluates to `4` and so `4` is the value that gets assigned to `spam`. 
## Output:
![image](https://github.com/user-attachments/assets/49328a39-582e-4d85-82fa-f757e91738d8)</br>
We can even use the variable itself to set the variable's new value. Try typing `spam = 10` and then `spam = spam + 1`.</br>
This assigns spam a new value. The new value for spam is equal to the current value of `spam + 1`. 
## Output:
![image](https://github.com/user-attachments/assets/457943fe-d774-4ffe-813d-44107ff4cd33) </br>
So if a Python instruction evaluates to a single value, it's an `expression`. Otherwise it's a `statement`. But mostly we just genericalld called them instructions or code.


# Sample_code:
```
#This is a simple hello world and name script

print('Hello World!')
print('What is your name?')
Myname = input()
print('Its good to meet you, ' + Myname)
print('The length of your name:')
print(len(Myname))
print('What is your age?')
Myage = input()
print('you will be ' + str(int(Myage) + 1) + ' next year')
```
Let's break down the code block step by step, along with the data types involved:
```
# This is a simple hello world and name script

print('Hello World!')

```
* Function: print()
* Data Type: The string 'Hello World!' is a str.
```
  print('What is your name?')
```
* Function: print()
* Data Type: The string 'What is your name?' is a str.
```
Myname = input()
```
* Function: print()
* Data Type: The user input is captured as a str and stored in the variable `Myname`.
```
print('Its good to meet you, ' + Myname)

```
* Function: print()
* Data Type: The concatenation of the strings 'Its good to meet you, ' and the Myname variable (which is a str) results in a str.
```
print('The length of your name:')
```
* Function: print()
* Data Type: The string 'The length of your name:' is a str.
```
print(len(Myname))
```
* Function: len()
* Data Type: The len(Myname) function returns an int, representing the number of characters in the string stored in Myname.
```
print('What is your age?')
```
* Function: print()
* Data Type: The string 'What is your age?' is a str.
```
  Myage = input()
```
* Function: input()
* Data Type: The user input is captured as a str and stored in the variable Myage.
```
print('you will be ' + str(int(Myage) + 1) + ' next year')
```
### * Function:
* `int(Myage)`: Converts the `str` input stored in `Myage` to an `int`.
* `+ 1`: Adds `1 ` to the integer value.
* `str(...)`: Converts the result back to a `str`.
* The final concatenation results in a `str`.

# Summary of Data Types Used:
* `str`: Used for all text strings `(e.g., prompts, messages)`.
* `int`: Used for numerical calculations `(e.g., converting age input to an integer)`.
## Flow of the Script:
* The script prints a greeting and asks for the user's name.
* It stores the name input and greets the user by name.
* It calculates and prints the length of the name.
* It then asks for the user's age, calculates what their age will be next year, and prints that information.</br>
* This is a simple interactive script that demonstrates basic input/output and type conversion in Python!





  
