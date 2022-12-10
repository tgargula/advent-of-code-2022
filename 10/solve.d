import std.stdio;
import std.algorithm;
import std.range;
import std.file;
import std.string;
import std.array;
import std.conv;

int[] get_intructions(string filename) {
    File file = File(filename, "r");

    int[] a = [0];
    auto instructions = appender(a);
    while (!file.eof()) {
        string s = chomp(file.readln());
        if (s == "noop"){
            instructions.put(0);
        } else {
            int op = s.split(" ")[1].to!int();
            instructions.put(0);
            instructions.put(op);
        }
    }

    file.close();

    return instructions[];
}

void main() {
    int step = 2;
    int width = 40;
    int height = 6;
    int[] instructions = get_intructions("data/input.txt");

    int value = 1;

    if (step == 1) {
        int sum = 0;
        foreach (i, e; instructions) {
            value = value + e;
            int c = cast(int) (i - 20 + 1);
            if (c >= 0 && c % 40 == 0) {
                sum += (i + 1) * value;
            }
        }

        writeln(sum);
    }
    if (step == 2) {
        for (int j = 0; j < height; j++) {
            string line = "........................................";
            for (int i = width * j; i < width * (j+1); i++) {
                if (i == value - 1 || i == value || i == value + 1) {
                    line = line.replace(i - width * j, i - width * j + 1, "#");
                }
                value = value + instructions[i + 1];
            }
            value += width;

            writeln(line);
        }
    }
}