from clips import Environment, Symbol

env = Environment()

# load rule
env.load('../Rule.clp')

# reset and clear environment
env.clear()
env.reset()

# run environment
env.run()