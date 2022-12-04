FILENAME = './data/input.txt'
PART = 2

function file_exists(filename)
    local file = io.open(filename, 'rb')
    if file then file:close() end
    return file ~= nil
end

function get_pairs(filename)
    if not file_exists(filename) then return {} end
    local lines = {}
    for line in io.lines(filename) do
        local pairs_list = nil
        for x1, x2, y1, y2 in string.gmatch(line, "(%d+)-(%d+),(%d+)-(%d+)") do
            pairs_list = {{tonumber(x1), tonumber(x2)}, {tonumber(y1), tonumber(y2)}}
        end
        lines[#lines + 1] = pairs_list
    end
    return lines
end

function fully_contains(a, b)
    return (a[1] <= b[1] and a[2] >= b[2]) or (b[1] <= a[1] and b[2] >= a[2])
end

function overlaps(a, b)
    return (a[2] >= b[1] and a[1] <= b[2]) or (b[2] >= a[1] and b[1] <= a[2])
end

function main()
    local lines = get_pairs(FILENAME)
    local counter = 0
    for i, line in pairs(lines) do
        if PART == 1 and fully_contains(line[1], line[2]) then
            counter = counter + 1
        end
        if PART == 2 and overlaps(line[1], line[2]) then
            counter = counter + 1
        end
    end

    print(counter)
end

main()
