# Distributed Operating System Principles Project 2

## Compiling and Running

Steps that tell you how to get project running.

1) Download and extract the zip file. 
2) Open CMD and navigate to the folder in the unzipped project.
3) Run the following commands
   ``` 
   mix escript.build
   # ./proj2 <number_of_nodes> <algorithm> <topology>
   .proj2 100 push-sum full
   
   ```
   - number_of_nodes = any integer
   - algorithm = {gossip, push-sum}
   - topology = {full, line, sphere, impline, grid3d, random2d}


  **The arguments can be changed here. The first number specifies the number of nodes, the second specifies the algorithm and the third the topology** 



## What is working
All 6 topologies for both Gossip and Push-Sum are working.  
## Largest Problem Solved

 - Gossip
    - Line: 100000
    - Full: 5000
    - Sphere: 10000
    - 3d: 10000
    - Random2d: 10000
    - Impline: 10000

- Push-Sum
  - Line: 10000
  - Full: 1000
  - Sphere: 5000
  - 3d: 1000
  - Random2d: 1000
  - Impline: 5000



## Built With

* [Elixir](https://elixir-lang.org/)
* [Mix](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)