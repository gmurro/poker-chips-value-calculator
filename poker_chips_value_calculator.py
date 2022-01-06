from minizinc import Instance, Model, Solver

try:
    # Load poker model from file and the data file
    model = Model("./poker_chips_value.mzn")
    model.add_file("./data.dzn", parse_data=True)
    # Find the MiniZinc solver configuration for Gecode
    gecode = Solver.lookup("gecode")
    # Create an Instance of the model for Gecode
    instance = Instance(gecode, model)

    # solve instance
    result = instance.solve()

    print("♠️♥ POKER CHIPS VALUE CALCULATOR ♦♣")

    # Output 
    if result.solution is None:
        print("❌ UNSATISFABLE problem ❌")
    else:
        print("🃏 Number of chips per color for each player: 🃏")
        for i, n in enumerate(result.solution.n_chips_for_player):
            print(f"\tColor {i}: {n}")
        decimal_places = len(str(result.solution.unit))-1
        print("\n💶 Value of each color chip: 💶")
        for i, v in enumerate(result.solution.value_chips_for_player):
            print(f"\tColor {i}: {v/result.solution.unit:.{decimal_places}f} €")
            
except AssertionError:
    print("Error! Move to the path of the folder where there is the model and the data")