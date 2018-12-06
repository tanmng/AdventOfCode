all_points = [
    (181, 184),
    (230, 153),
    (215, 179),
    (84, 274),
    (294, 274),
    (127, 259),
    (207, 296),
    (76, 54),
    (187, 53),
    (318, 307),
    (213, 101),
    (111, 71),
    (310, 295),
    (40, 140),
    (176, 265),
    (98, 261),
    (315, 234),
    (106, 57),
    (40, 188),
    (132, 292),
    (132, 312),
    (97, 334),
    (292, 293),
    (124, 65),
    (224, 322),
    (257, 162),
    (266, 261),
    (116, 122),
    (80, 319),
    (271, 326),
    (278, 231),
    (191, 115),
    (277, 184),
    (329, 351),
    (58, 155),
    (193, 147),
    (45, 68),
    (310, 237),
    (171, 132),
    (234, 152),
    (158, 189),
    (212, 100),
    (346, 225),
    (257, 159),
    (330, 112),
    (204, 320),
    (199, 348),
    (207, 189),
    (130, 289),
    (264, 223),
]

# all_points = [
#     (1, 1),
#     (1, 6),
#     (8, 3),
#     (3, 4),
#     (5, 5),
#     (8, 9),
# ]

print("hello")
print(len(all_points))

# Find min max of all axis, we use that to find out which one is infinitely and thus will not count
minx = min(point[0] for point in all_points)
miny = min(point[1] for point in all_points)
maxx = max(point[0] for point in all_points)
maxy = max(point[1] for point in all_points)

print('Min X' + str(minx));
print('Max X' + str(maxx));

print('Min Y' + str(miny));
print('Max Y' + str(maxy));

# Process the list and find their distance
distant_list = []

index_of_point_with_infinite = []

def distance(pointa, pointb):
    return abs(pointa[0] - pointb[0]) + abs(pointa[1] - pointb[1])

safe_zone = []
safe_zone_limit = 10000

# Better way to find points which have infinite space
for y in range(miny, maxy + 1):
    left_edge_point = (minx, y)
    edge_distance_list = [distance(left_edge_point, point) for point in all_points]
    min_distance = min(edge_distance_list)
    point_with_infinite_indice = [i for i, dis in enumerate(edge_distance_list) if dis == min_distance]
    if len(point_with_infinite_indice) == 1:
        index_of_point_with_infinite.extend(point_with_infinite_indice)

    # Right edge
    right_edge_point = (maxx, y)
    edge_distance_list = [distance(right_edge_point, point) for point in all_points]
    min_distance = min(edge_distance_list)
    point_with_infinite_indice = [i for i, dis in enumerate(edge_distance_list) if dis == min_distance]
    if len(point_with_infinite_indice) == 1:
        index_of_point_with_infinite.extend(point_with_infinite_indice)

for x in range(minx, maxx + 1):
    upper_edge_point = (x, miny)
    edge_distance_list = [distance(upper_edge_point, point) for point in all_points]
    min_distance = min(edge_distance_list)
    point_with_infinite_indice = [i for i, dis in enumerate(edge_distance_list) if dis == min_distance]
    if len(point_with_infinite_indice) == 1:
        index_of_point_with_infinite.extend(point_with_infinite_indice)

    # lower edge
    lower_edge_point = (x, maxy)
    edge_distance_list = [distance(lower_edge_point, point) for point in all_points]
    min_distance = min(edge_distance_list)
    point_with_infinite_indice = [i for i, dis in enumerate(edge_distance_list) if dis == min_distance]
    if len(point_with_infinite_indice) == 1:
        index_of_point_with_infinite.extend(point_with_infinite_indice)

print(set(index_of_point_with_infinite))

for i, point in enumerate(all_points):
    if i in index_of_point_with_infinite:
        # infinite - infinite points in this point distance grid
        distant_list.append(-1)
    else:
        # we can count this point
        distant_list.append(0)

for x in range(minx, maxx + 1):
    for y in range(miny, maxy + 1):
        # Go through all the points in the grid
        cur_point = (x, y)

        # Get the distance from current point to the mark point
        cur_distances = [distance(cur_point, point) for point in all_points]
        min_distance = min(cur_distances)

        if (sum(cur_distances) < safe_zone_limit):
            safe_zone.append(cur_point)

        if cur_distances.count(min_distance) > 1:
            # More than 1 point can be closest - skip this
            continue
        min_dis_index = cur_distances.index(min_distance)

        # got the min one
        if distant_list[min_dis_index] < 0:
            # This is a negative point (which has infinite min distance point, so we don't really need to care)
            distant_list[min_dis_index]-=1
        if distant_list[min_dis_index] >= 0:
            # This is the case that we shoudl care
            distant_list[min_dis_index]+=1

print("Part1")
print(distant_list)
print(max(distant_list))

print("Part2")
print(len(safe_zone))
