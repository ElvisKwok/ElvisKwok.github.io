---
layout: post
title: Note of KLA
---

#{{ page.title }}  
<p class="meta">22 Dec 2014 - Guangzhou</p> 

---

### KLA: A New Algorithmic Paradigm for Parallel Graph Computation
*best paper awarded of PACT 2014*

## Abstract:
* KLA(K-Level Asychronous): an algorithmic paradigm that bridges level-synchronous and asynchronous paradigms for processing graphs.
* K: the number of asynchronous steps allowed **between** global synchronizations.
* Parametrically control the level of asynchrony in parallel graph algorithms(level-synchronous -> partially asynchronous -> completely asynchronous).
* Motivation: improve exection times.
    + level-synchronous: few, but expensive **global** synchronizations.
    + asychronous: more, but not so expensive **local** synchronizations(perhaps with redundant work).
    + trade-off.
* KLA paradigm is available for graph algorithm commonly.
* Techniques for determining k.
* Implementation of KLA in the [SGL][](STAPL Graph Library). 
* Scalability: 96K cores.
* Performance improvement: 10x over trad-alg(level-synchronous and asychronous versions).
<br>

## 1. Introduction
* Parallelization need.
    + Traversals, a important type and backbone of other graph algorithms(shortest path, centrality metrics, connected components). Traversal-based computations remain difficult to parallelize effectively.
    + Random walks(e.g., PageRank) for web link-analysis, k-core decomposition for social networks study, need effective parallelization.
* Level-synchronous paradigm.
    + Iteratively process vertices level by level(current level's computation has to completed **before** next level) through global synchronizations at the end of each level.
    + Performance depend on the number of levels(small -> well, large -> poor scalability)
    + E.g., BSP(Bulk Synchronous Parallel).
* Asychronous paradigm.
    + Point-to-point synchronization(which can increase the degree of parallelism).
    + Drawback: may require redundant work(e.g., asynchronous BFS re-visit vertices when shorter paths are discovered).
* Right paradigm? depends on systems, input graphs and algorithms.
* A new paradigm: KLA, common interface, easy to switch.
* 3 contribution of this paper.
    + KLA. Level of aynchrony: estimate a proper level k, and a adaptive stategy.  
    + Application of KLA to standard graph computation.
    + Scalable performance.
<br>

## 2. The KLA Paradigm
* This paradigm works in phases(like BSP model). Each phase(BSP's Superstep) allow (up to)k asynchronous steps by creating asynchronous tasks on active vertices.
    + K = 1, level-synchronous;
    + K >= d, asynchronous(d: number of iteration need for level-sync); 
    + 1 < k < d, ![img][d_k] phases, called KLA supersteps(KLA-SS).
* Pseudocode, 2 functions(user provide): vertex-operator, neighbor-opeartor.
    + vertex-operator: be performed on each vertices, return true when the vertex is active(vertex's value is updated by vertex-operator, or the vertex visits neighbor vertices).
    + neighbor-operator: visit neighbor vertices.
    + map, reduce -> active?  
 
![img][pseudocode]  

### 2.1 KLA Breath-First Search
* Perform BFS in parallel previously: level-synchronous, asynchronous
* Comparison: level-synchronous, asynchronous and KLA versions of BFS.
    + Stay the same: driver of BFS, BFS vertex and neighbor operators. 
    + Changed: the Visit logic.(allow the computation to proceed on the neighbor vertex being visited?)
* To complete the KLA BFS, we need to provide generic BFS vertex and neighbor operators.
    + Vertex-operator: 3 functions provided by KLA paradim(Visit, VisitALLNeighbors, VisitNeighborIf), or other user-defined function.
    + neighbor-operator: requirements: like asynchronous BFS, it cannot rely on the order in which the vertex is visited, and must be resilient to multiple visits.
* Algorithm terminates when all vertices are inactive. 
* Prove the correctness of the KLA BFS.

### 2.2 KLA and the △-Stepping SSSP Algorithm
* △-Stepping SSSP Algorithm
    + *Multiple* **light** egdes are processed *simultaneously* in a single superstep.
    + **light** means in superstep i, the tentative distance of an egde's source fall between i△ and (i+1)△.
    + Then, **heavy** edges are processed at the end of superstep.
* What KLA is better than △-stepping SSSP algorithm: generality.
    + △-stepping SSSP is not applicable to non-SSSP based algorithm    
    + KLA works on the structure of the graph, and not algorithm specifics.
    + KLA is a generalization and extension of the △-stepping algorithm(more experimental comparison in section 5.6)
<br>

## 3. Applying KLA To Algorithms 
### 3.1 Analysis of Example Algorithms in KLA
　　BFS, k-core and PageRank that display different asynchronous characteriscs. If we increase the asynchrony in a algorithm, it may cost either no penalty paid(k-core decomposition, topological sort) or redundant work(BFS)(to correct previous value due to the out-of-order arrival of messages).  
　　Best performance is obtained by balancing the penalty, which is done by limiting the size of asynchronous sections(depth k) in KLA.

* Breadth-First Search and Graph Traversal  
    + In a complete asynchronous version of BFS, the number of incoming messages(new distance) is unknown a priori, so the BFS computation must propagate every message it receives, leading to redundant work.
    
* k-core Decomposition.
    + A k-core of a graph G is a maximal connected sub-graph of G in which all vertices have degree at least k.
    + Initialize counters of each vertex's degree, if a vertex is deleted(degree < k), then propagate the message, then the neighbor's counter decrease by 1.
    + No penalty for increasing asynchrony: the number of messages required for a propagation is known(the degree of the vertex).
    + Unaffected by the order in which the messages are received.
    + The parallel topological sort algorithm is similar.(propagate when in-degree becomes 0)

* PageRank：PageRank is a graph algorithm that used to rank web-pages in order of relative importance.
    + A kind of random walk algorithm, each vertex calculate its rank in iteration *i* base on the ranks of its neighbors in iteration *i*-1, then send new ranks to its neighbor for next iteration.
    + Level-synchronous, but it can be converted to KLA.
        - A vertex receive ranks of all its neighbors from iteration *i*-1, so must count how many ranks received from previous iteration
        - In an asynchronous excution, the vertex may receive ranks for a future iteration **before** all ranks from iteration *i*-1 have been received.
        - sollution: buffer the early rank in a two-dimesional table, indexed by iteration *i*, for future use.
    + Summary: PageRank knows the number of messages to receive before propagate, but require the order of messages.
    + Increasing asychrony may increase the amount of message buffered, other random walk algorithm as well.(pointer jumping and graph coloring)

### 3.2 KLA Algorithmic Categories
The penalty paid for increasing asynchrony depends on 2 properties(of message receiving from neighbor):

* Ordering: is it resilient that message arrive in advance?
* Message Count: the number of messages to activate each vertex is known or unknown?
Characteristics of the three categories of KLA algorithms are as follows:  
![img][KLA_category]  
<br>

## 4. Determining k
Two techniques to determine k:

* An adaptive strategy(based on current local topology of the graph), applicable in the general case.
* Approximate value for the optimal value of k(Kopt).

### 4.1 Adaptive Determination of k
Choose the best value for the next iteration based on information from current and previous iterations.

* Initialize k = 1
* At the end of each KLA superstep(KLA-SS), k = k * 2 if:
    + high out-degree vertices have not been discovered.
    + the penalty for asynchrony has not exceed a threshold.
    + the cost of processing each vertex in the current KLA-SS is ≤ the cost of processing each vertex for the previous KLA-SSs.
* k = k / 2 if:
    + out-degree || asynchrony penalty || per-vertex processing cost exceed the thresholds.
* Mark the high out-degree vertices, process it in the next KLA-SS, so as to reduce the penalty of prematurely processing.
* To control aynchrony penalty, k is capped when the asynchrony penalty || processing cost exceed a maximum threshold(20%).
* Thresholds are depend on the machine(if cost of communication > computation, increase the threshold, vice versa)
* Summary: performance: not as good as knowing a Kopt, but this technique is inexpensive, and better than level-syn/asyn paradigm because of the converging improved k value.

### 4.2 A Model for Approximating Kopt
Describe a model to obtain a good approximation of the value Kopt for k(lowest execution time), start with **Type-I**.

* Theoretical Model:
    + Level-synchronous BFS
        + Parameters: d iteration, n vertices, p processors, Vmax(ideally, n/p) is the max number of vertices processed by a processor, α average time to excute each vertex, Tsync is the time for global-synchronization of p processors in each iteration. 
        + Total time:  
        ![img][level-syn_BFS]  
    + Asynchronous BFS
        + Parameters: ψ(G) is the amount of redundant work, ![img][symbol_1] is the amount of redundant work per processor.
        + Total time:  
        ![img][asyn_BFS]  
    + KLA BFS
        + Parameters: ![img][d_k] KLA-SS, ψ(G, k) is the amount of redundant work for a given k, ψ(G, 1) = 0 adn ψ(G, d) = ψ(G)
        + Total time:  
        ![img][KLA_BFS_1]  
        ![img][KLA_BFS_2]  
* Modeling the Wasted Work, ψ(G, k)
    + Edge sets: Et(BFS tree), Ent = E-Et, Ent\_c(Ent edges that cross a KLA-SS), Ent\_i(inside a KLA-SS).
    + Estimate the wasted work as the cardinality of the set Ent\_i.  
    ![img][wasted_work_1]  
    ![img][wasted_work_2]  

    + Conclution: 
        + As to small-diameter graphs with large out-degree(E >> V) and d = O(1), a slight increase of k lead to large amounts of wasted work. So a smaller k value would be better(like k = 1).
        + As to long-diameter graphs with low out-degree(E ≈ V) and d = O(V), wasted work is negligible so best with k = d.
        + Others fall in-between, 1 < k < d.

* **Ordered Type-II Algorithms**
    + Parameters: β is buffering cost(constant for a given system), penalty-function ψest(G, k) = m x k + b, m and b is the constants depending on input-graph and machine.
    + Total time:  
    ![img][ordered_type-II]  
    + m and b can be computed by runnning the algorithm twice with 2 different k values.

* **Unordered Type-II Algorithms**  
　　As to this type, there is no penalty for increasing asynchrony. But for certain graphs with large out-degrees, massive messages cause network congestion, so level-synchronous may be better.  
　　To find the equation of ψest(G, k) = m x k + b
    + run the algorithm with k = 1(level-sync), to obtain d and α
    + run the algorithm with k = d(Async), to get ψest
 
* predicted excution time of the model compare to actual excution time.  
![img][predicted_excution_time]  
<br>

## 5. Experiments
### 5.1 Experimental Setup and Input Graphs
* Setup: Hopper - a Cray XE6 machine at the National Energy Research Scientific Computing Center (NERSC), use 98,304 cores of it.
* Input graphs:  
![img][input_graphs]  

### 5.2 SGL Overview
　　STAPL(the Standard Template Adaptive Parallel Library) is a framework for developing parallel programs in C++. It is designed to work on both shared and distributed memory parallel computers.
　　A library of components implementing parallel algorithms(pAlgorithms) and distributed data structures(pContainers).

### 5.3 Level-Synchronous vs. Asynchronous BFS
Graph 500: short diameter  
3D Toroid Graph: serialized  
![img][syn_vs_asyn]  

* Conclusion: performance benefit of correct paradigm to the graph topology

### 5.4 Evalutaion of KLA BFS
Evaluate the **performance** benefit and **scalability** of KLA BFS, k > 1 provides the best performance from the observation.

* Graph Structure and Kopt
    + deforming shape to vary the diameter from 128k to 8.
    + ran KLA BFS on each deformation fro varying values of k.
    + best k according to the graph diameter is as follow:  
    ![img][best_k]  
* Road Network Graphs   
![img][road_network]  
    + Best performance is obtained with 1 < k < d
    + 27-33% faster than the fastest traditional paradigm  
![img][synthetic_road_network]  
    + scalability: 98,304 cores(KLA) vs. 32,768 cores(level-syn)
    + faster: better balancing synchronization costs.

### 5.5 Evalutaion of Adaptive KLA BFS 
* Choose the better one of level-sync and async paradigm as a baseline,speedups are as follows:  
![img][speed_up]  

* Compare to KLA with Kopt, Adaptive KLA BFS required:
    + overhead of adaptivity(a few iteration to converge)
    + monitoring the iterations(for wasted work)

### 5.6 Evalutaion of Other Types of Algorithms
The figure below shows the speedup(k-core and PageRank of KLA vs. level-sync, Δ-stepping of KLA vs. non-KLA).   
![img][other_alg]  

* k-core(note: fully asynchronous is suit for most graph, but for Google web-graph that with high out-degree, level-sync is set due to network congestion caused by messages)
* PageRank
* Δ-stepping for SSSP

### 5.7 KLA with Other Graph Frameworks
* KLA with Green-Marl
    + KLA could be called recursively in nested sections using a tuple of k values, each k is for each level of nesting.
    + Hybrid KLA: combination of Green-Marl and KLA 
        + an optimized shared-memory library(Green-Marl) for processing graph partitions on a shared-memory node.
        + KLA on the upper-level to extend it across distributed nodes.
    + experiments: PageRank and cut-conductance.   
    ![img][green-marl]  
* KLA in Galois  
    + Galois rely on shared-memory worklists(task scheduling).
        - bulk-synchronous worklist: two queues one after one.
        - asynchronous worklist: serveral queues processed in any order.
    + KLA worklist for Galois: modify bulk-sync worklist, async-executing in KLA-SS, sync after K levels of async.  
    + improvements in long diameter graphs.  
    
![img][galois]  
<br>


## 6. Related Work
* Level-sync: Google's Pregel, Parallel Boost Graph Library(PBGL), Multi-Threaded Graph Library(MTGL); GRACE and Galois.
* Asyn: GraphLab/PowerGraph, Δ-stepping for SSSP.
* domain-specific languages(DSLs) for graph processing, like Green-Marl.
* KLA: although exist two way of expressing parallel graph algorithms, parametrically controlling has not been studied.
<br>


## 7. Conclusion 

* Parametrically control the level of asynchrony
* How to express graph algorithms in KLA paradigm
* Determining k
* scalability and performance
<br>


[SGL]: https://parasol.tamu.edu/groups/rwergergroup/research/stapl

[d_k]: /images/KLA/d_k.png
[pseudocode]: /images/KLA/pseudocode.png
[KLA_category]: /images/KLA/KLA_category.png
[level-syn_BFS]: /images/KLA/level-syn_BFS.png
[symbol_1]: /images/KLA/symbol_1.png
[asyn_BFS]: /images/KLA/asyn_BFS.png
[KLA_BFS_1]: /images/KLA/KLA_BFS_1.png
[KLA_BFS_2]: /images/KLA/KLA_BFS_2.png
[wasted_work_1]: /images/KLA/wasted_work_1.png
[wasted_work_2]: /images/KLA/wasted_work_2.png
[wasted_work_3]: /images/KLA/wasted_work_3.png
[ordered_type-II]: /images/KLA/ordered_type-II.png
[predicted_excution_time]: /images/KLA/predicted_excution_time.png
[input_graphs]: /images/KLA/input_graphs.png
[syn_vs_asyn]: /images/KLA/syn_vs_asyn.png
[best_k]: /images/KLA/best_k.png
[road_network]: /images/KLA/road_network.png
[synthetic_road_network]: /images/KLA/synthetic_road_network.png
[speed_up]: /images/KLA/speed_up.png
[other_alg]: /images/KLA/other_alg.png
[green-marl]: /images/KLA/green-marl.png
[galois]: /images/KLA/galois.png
