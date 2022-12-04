use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashSet;

fn main() {
    if let Ok(lines) = read_lines("./data/input.txt") {
        let mut vector = Vec::new();
        for line in lines {
            if let Ok(items) = line {
                let compartments = get_compartments(items);
                let common = get_common(compartments);
                if let Ok(res) = common {
                    let priority = get_priority(res);
                    vector.push(priority);
                }
            }
        }

        println!("{}", vector.iter().sum::<i32>())
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn get_compartments(items: String) -> (String, String) {
    let size = items.chars().count();
    let first = &items[0..size/2];
    let second = &items[size/2..size];

    (first.to_string(), second.to_string())
}

fn get_common((a, b): (String, String)) -> Result<char, Option<char>> {
    let mut set1 = HashSet::new();
    let mut set2 = HashSet::new();

    for letter in a.chars() {
        set1.insert(letter);
    }
    for letter in b.chars() {
        set2.insert(letter);
    }

    let common = set1.intersection(&set2).next().ok_or(' ')?;
    Ok(*common)
}

fn get_priority(letter: char) -> i32 {
    if letter >= 'a' && letter <= 'z' {
        return letter as i32 - 'a' as i32 + 1;
    }
    return letter as i32 - 'A' as i32 + 27;
}
