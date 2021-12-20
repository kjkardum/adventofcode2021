use std::{fs::File, io::prelude::*, io::BufReader};

fn main() {
    let lines = read_input("input.txt");
    let (algorithm, mut image) = parse_input_lines(lines);
    for round in 0..50 {
        let new_img = enhance(&image, &algorithm);
        image = new_img;
        if round == 1 {
            println!("Part 1: {}", &image.iter().map(|row| row.chars().filter(|&x| x=='#').count()).sum::<usize>());
        }
    }
    println!("Part 2: {}", &image.iter().map(|row| row.chars().filter(|&x| x=='#').count()).sum::<usize>());
}

fn enhance(img: &Vec<String>, algorithm: &str) -> Vec<String> {
    let mut new_img = img.clone();
    for row in 1..(img.len()-1) {
        for col in 1..(img[row].len()-1) {
            let square = format!("{}{}{}", &img[row-1][col-1..col+2], &img[row][col-1..col+2], &img[row+1][col-1..col+2]);
            let as_num = usize::from_str_radix(&square.replace(".","0").replace("#","1"),2).unwrap();
            let new_value = &algorithm.chars().nth(as_num).unwrap().to_string();
            new_img[row].replace_range(col..(col+1), new_value);
        }
    }
    new_img.remove(0);
    new_img.remove(new_img.len()-1);
    for row in &mut new_img {
        row.remove(0);
        row.remove(row.len()-1);
    }
    new_img
}

fn parse_input_lines(vec: Vec<String>) -> (String, Vec<String>) {
    let head = vec[0].clone();
    const N: usize = 110;
    let len = vec.len() - 2;
    let mut tail = (0..N).map(|_|".".repeat(len + 2*N)).collect::<Vec<String>>();
    tail.extend(vec.into_iter().skip(2).map(|s| ".".repeat(N) + &s + &".".repeat(N)).collect::<Vec<String>>());
    tail.extend((0..N).map(|_|".".repeat(len + 2*N)).collect::<Vec<String>>());
    (head, tail)
}

fn read_input(filename: &str) -> Vec<String> {
    let file = File::open(filename).expect("file not found.");
    let reader = BufReader::new(file);
    reader
        .lines()
        .map(|l| l.expect("Can't read line"))
        .collect()
}