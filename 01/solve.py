FILENAME = 'data/input.txt'
STEP = 2

if __name__ == '__main__':
    with open(FILENAME, 'r') as f:
        elves = [0]
        for calories in f.readlines():
            calories = calories.strip()
            if calories == '':
                elves.append(0)
            else:
                elves[-1] += int(calories)
    
    if STEP == 1:
        print(max(elves))
    elif STEP == 2:
        top = sorted(elves)[-3:]
        print(sum(top))
