import numpy as np
def solve_tspd_RL_test(n_nodes, n_groups, n_samples):
    n_runs = 10
    obj_DPS = np.zeros(n_runs)
    obj_RL = np.zeros(n_runs)
    for i in range(n_runs):
        x = np.random.rand(n_nodes) * 100
        y = np.random.rand(n_nodes) * 100
        x[0] = np.random.rand()  # depot
        y[0] = np.random.rand()  # depot

        result1 = solve_tspd(x, y, 1.0, 0.5, n_groups=n_groups)
        obj_DPS[i] = result1.total_cost

        result2 = solve_tspd_RL(x, y, n_samples=n_samples)
        obj_RL[i] = result2.total_cost

    pct_gap = (np.mean(obj_RL) - np.mean(obj_DPS)) / np.mean(obj_DPS)
    print("Mean DPS cost:", np.mean(obj_DPS))
    print("Mean RL cost:", np.mean(obj_RL))
    print("Percentage gap:", pct_gap)
    assert pct_gap < 0.05
    return np.mean(obj_DPS), np.mean(obj_RL), pct_gap

def test_RL():
    sizes = [11, 15, 20, 50, 100]
    n_groups = [1, 1, 2, 5, 10]
    n_samples = 10
    results = np.zeros((len(sizes), 3))
    for i in range(len(sizes)):
        print(f"Testing n = {sizes[i]} / DPS: n_groups = {n_groups[i]} / RL: n_samples = {n_samples}")
        results[i, :] = solve_tspd_RL_test(sizes[i], n_groups[i], n_samples)
