let filename = "data/input.txt"
let step = 2

(* Positions where the data starts *)
let parser_pointers = [7; 18; 19; 21; 29; 30; 0]

class monkey id items operation test (passed : int) (failed : int) =
object (self)
  val mutable stack = items
  val mutable ctr = 0

  (* For debugging *)
  method print_items =
    List.iter (Printf.printf "%d, ") stack;
    Printf.printf "\n"

  (* For debugging *)
  method show =
    Printf.printf "%d(%d): " id ctr;
    self#print_items

  method get_ctr = ctr

  method get_test = test

  method push item = 
    stack <- item :: stack

  method pop =
    let result = List.hd stack in
    stack <- List.tl stack;
    result

  method empty =
    List.length stack == 0

  method process mul = 
    ctr <- ctr + 1;
    let item = self#pop in
    (* See: https://en.wikipedia.org/wiki/Chinese_remainder_theorem *)
    let worried = if step == 1 then operation item / 3 mod mul else operation item mod mul in
    if worried mod test == 0 then [worried; passed] else [worried; failed]
end;;

class monkey_builder =
  object
    val mutable id = -1
    val mutable items = ([]: int list)
    val mutable operation : int -> int = fun _ -> -1
    val mutable test = -1
    val mutable passed = -1
    val mutable failed = -1
    val mutable monkeys_ref : int list ref = ref []

    method set_id identifier =
      id <- identifier
    method print_id =
      Printf.printf "id: %d\n" id
    method set_items new_items =
      items <- new_items
    method set_operation new_operation = 
      operation <- new_operation
    method set_test new_test = 
      test <- new_test
    method set_passed new_passed = 
      passed <- new_passed
    method set_failed new_failed = 
      failed <- new_failed

    method build =
      new monkey id items operation test passed failed
  end;;

class monkey_manager monkeys =
  object (self)
    val monkeys : monkey list ref = monkeys

    method get_test_mul =
      List.fold_left (fun prev curr -> prev * curr) 1 (List.map (fun monkey -> monkey#get_test) !monkeys)

    method serve monkey =
      while not monkey#empty; do
        let result = monkey#process self#get_test_mul in
        let item = List.hd result in
        let next_id = List.hd (List.tl result) in
        let next = List.nth !monkeys next_id in
        next#push item
      done;
    
    method serve_all iter =
      let range = List.init iter (fun x -> x) in
      List.iter (fun _ -> List.iter self#serve !monkeys) range
  end;;

let create_monkeys lines =
  let monkeys = ref [] in
  let monkey_builder = new monkey_builder in
  
  let input_handler = fun i line ->
    let ptr = i mod 7 in
    let ptr_position = List.nth parser_pointers ptr in
    match ptr with
      | 0 -> 
        (* -1 to remove ":" *)
        let id = (int_of_string (String.sub line ptr_position (String.length line - ptr_position - 1))) in
        monkey_builder#set_id id

      | 1 ->
        let items_string = String.sub line ptr_position (String.length line - ptr_position) in
        let items_list = List.map String.trim (String.split_on_char ',' items_string) in
        let items = List.map int_of_string items_list in
        monkey_builder#set_items items

      | 2 ->
        let operation_string = String.sub line ptr_position (String.length line - ptr_position) in
        let operation_list = String.split_on_char ' ' operation_string in
        let op = fun x y ->
          match (List.nth operation_list 1) with
          | "*" -> (x * y)
          | "+" -> (x + y)
          | _ -> -1
        in
        let parse = fun old value ->
          match value with
          | "old" -> old
          | _ -> int_of_string value
        in
        let operation = fun old ->
          op (parse old (List.hd operation_list)) (parse old (List.nth operation_list 2))
        in
        monkey_builder#set_operation operation

      | 3 ->
        let test = int_of_string (String.sub line ptr_position (String.length line - ptr_position)) in
        monkey_builder#set_test test
        
      | 4 ->
        let passed = int_of_string (String.sub line ptr_position (String.length line - ptr_position)) in
        monkey_builder#set_passed passed

      | 5 ->
        let failed = int_of_string (String.sub line ptr_position (String.length line - ptr_position)) in
        monkey_builder#set_failed failed;
        monkeys := (monkey_builder#build) :: !monkeys

      | _ -> () in
    
  List.iteri input_handler lines;
  monkeys := List.rev !monkeys;
  
  monkeys;;

let read_file filename =
  let lines = ref [] in
  let file = open_in filename in
  try 
    while true; do
      lines := input_line file :: !lines
    done;
    !lines
  with End_of_file ->
    close_in file;
    List.rev !lines;;

let () =
  let lines = read_file filename in
  let monkeys = create_monkeys lines in
  let manager = new monkey_manager monkeys in
  let iterations = if step == 1 then 20 else 10000 in
  manager#serve_all iterations;

  let sorted_iters = List.sort (fun a b -> b#get_ctr - a#get_ctr) !monkeys in 
  let result = (List.hd sorted_iters)#get_ctr * (List.hd (List.tl sorted_iters))#get_ctr in
  Printf.printf "%d\n" result;;
