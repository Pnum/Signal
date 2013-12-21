Noise
	Modifier
		Terrace
			source_count_req = 1

			var
				invert_terraces = FALSE
				list/control_points
				control_point_count

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				var
					source_value = source.get3(x, y, z)
					index_pos = 0

				for(index_pos = 0, index_pos < control_point_count, index_pos ++)
					if(source_value < control_points[index_pos + 1])
						break

				var
					index0 = min(max(index_pos - 1, 0), control_point_count - 1)
					index1 = min(max(index_pos, 0), control_point_count - 1)

				if(index0 == index1)
					return control_points[index1 + 1]

				var
					value0 = control_points[index0 + 1]
					value1 = control_points[index1 + 1]
					alpha = (source_value - value0) / (value1 - value0)

				if(invert_terraces)
					alpha = 1 - alpha
					var/t = value0
					value0 = value1
					value1 = t

				alpha *= alpha

				return ((1 - alpha) * value0) + (alpha * value1)

			get2(x, y)
				x += seed
				y += seed

				var
					source_value = source.get2(x, y)
					index_pos = 0

				for(index_pos = 0, index_pos < control_point_count, index_pos ++)
					if(source_value < control_points[index_pos + 1])
						break

				var
					index0 = min(max(index_pos - 1, 0), control_point_count - 1)
					index1 = min(max(index_pos, 0), control_point_count - 1)

				if(index0 == index1)
					return control_points[index1 + 1]

				var
					value0 = control_points[index0 + 1]
					value1 = control_points[index1 + 1]
					alpha = (source_value - value0) / (value1 - value0)

				if(invert_terraces)
					alpha = 1 - alpha
					var/t = value0
					value0 = value1
					value1 = t

				alpha *= alpha

				return ((1 - alpha) * value0) + (alpha * value1)

			proc
				setInvertTerraces(_invert_terraces = FALSE)
					invert_terraces = _invert_terraces

				getInvertTerraces()
					return invert_terraces

				getControlPoints()
					return control_points

				addControlPoint(value)
					insertAtPos(findInsertionPos(value), value)

				clearAllControlPoints()
					control_points = null
					control_point_count = 0

				findInsertionPos(value)
					var/insertion_pos = 0
					for(insertion_pos = 0, insertion_pos < control_point_count, insertion_pos ++)
						if(value < control_points[insertion_pos + 1])
							break

						else if(value == control_points[insertion_pos + 1])
							CRASH("Non-unique control point!")

					return insertion_pos

				insertAtPos(insertion_pos, value)
					var/list/new_control_points = new/list(control_point_count + 1)
					for(var/i = 0, i < control_point_count, i ++)
						if(i < insertion_pos)
							new_control_points[i + 1] = control_points[i + 1]

						else
							new_control_points[i + 2] = control_points[i + 1]

					control_points = new_control_points
					control_point_count ++
					control_points[insertion_pos + 1] = value

				makeControlPoints(control_point_count = 2)
					ASSERT(control_point_count >= 2)

					clearAllControlPoints()

					var
						terrace_step = 2 / (control_point_count - 1)
						cur_value = -1

					for(var/i = 0, i < control_point_count, i ++)
						addControlPoint(cur_value)
						cur_value += terrace_step