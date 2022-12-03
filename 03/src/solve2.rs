use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    if let Ok(lines) = read_lines("./data/input.txt") {
        let mut vector: Vec<i32> = Vec::new();
        let rucksacks: Vec<String> = lines.map(|l| l.expect("Could not parse line")).collect();
        let chunks = rucksacks.chunks(3);

        for chunk in chunks {
            let mut iter = chunk.iter();
            let common = get_common3(
                iter.next().expect(""),
                iter.next().expect(""),
                iter.next().expect(""),
            );
            vector.push(get_priority(common.expect("Must be defined")));
        }

        println!("{}", vector.iter().sum::<i32>())
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file: File = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn get_common3(a: &str, b: &str, c: &str) -> Result<char, Option<char>> {
    let mut set1: HashSet<char> = HashSet::new();
    let mut set2: HashSet<char> = HashSet::new();
    let mut set3: HashSet<char> = HashSet::new();

    for letter in a.chars() {
        set1.insert(letter);
    }
    for letter in b.chars() {
        set2.insert(letter);
    }
    for letter in c.chars() {
        set3.insert(letter);
    }

    let common2: HashSet<char> = set1.intersection(&set2).copied().collect();
    let common: &char = common2.intersection(&set3).next().ok_or(' ')?;
    Ok(*common)
}

fn get_priority(letter: char) -> i32 {
    if ('a'..='z').contains(&letter) {
        return letter as i32 - 'a' as i32 + 1;
    }
    letter as i32 - 'A' as i32 + 27
}
