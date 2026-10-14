This is a program made for the sake of learning languages, more specifically for learning an alphabet (or an equivalent of one) of a specific language.

How to work it:
First, you have to open this repository with the godot editor to run this program, there is no included way of running the program by itself.
This program uses godot 4.6

In the dictionaries folder, input your dictionary file. A dictionary file is a .txt file and has this format:

(question) <br>
(answer)

and so on and so forth (see the already present dictionaries for examples)

Once you start the program, you can select which dictionaries you want to include, the enemy lifetime and enemy spawn interval (both in seconds).
After the spawn interval, an "enemy" (just a piece of text) presenting the (question) will appear, and you have to type in the (answer) that was contained in the dictionary to make it disappear. 

For example, if what was in the dictionary looked like this:

ちょ <br>
cho

then an enemy would appear with "ちょ" written, and you'd have to type "cho" to make it disappear. If you don't manage to type the right answer within the lifetime of the enemy, it will reveal the answer and disappear.
The enemies turn different colors to indicate a certain status:

White: no wrong character has been inputted yet
Yellow: a wrong character has been inputted
Red: the enemy's lifetime expired and the right answer was not inputted.
Green: the right answer was inputted
