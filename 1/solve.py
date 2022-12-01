if __name__ == '__main__':
    step = 2

    with open('1/input.txt', 'r') as f:
        elves = [0]
        for calories in f.readlines():
            calories = calories.strip()
            if calories == '':
                elves.append(0)
            else:
                elves[-1] += int(calories)
    
    if step == 1:
        print(max(elves))
    elif step == 2:
        top = sorted(elves)[-3:]
        print(sum(top))