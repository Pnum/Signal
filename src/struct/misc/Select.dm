Noise
	Select
		source_count_req = 3

		var
			Noise/source2
			Noise/source3

			lower_bound = -1
			upper_bound = 1
			edge_falloff = 0

		New(Noise/_source, Noise/_source2, Noise/_source3)
			if(_source)
				addSource(_source)
				if(_source2)
					addSource(_source2)
					if(_source3)
						addSource(_source3)

		addSource(Noise/_source)
			..(_source)

			if(length(sources) == 2) source2 = sources[2]
			else if(length(sources) == 3) source3 = sources[3]

		proc
			setBounds(_lower_bound, _upper_bound)
				ASSERT(_lower_bound < _upper_bound)
				lower_bound = _lower_bound
				upper_bound = _upper_bound

				setEdgeFalloff(edge_falloff)

			setEdgeFalloff(_edge_falloff)
				var/bound_size = upper_bound - lower_bound
				edge_falloff = (_edge_falloff > bound_size / 2) ? bound_size / 2 : _edge_falloff

		get2(x, y)
			x += seed
			y += seed

			var
				control_value = source3.get2(x, y)
				alpha

			if(edge_falloff > 0)
				if(control_value < (lower_bound - edge_falloff))
					return source.get2(x, y)

				else if(control_value < (lower_bound + edge_falloff))
					var
						lower_curve = lower_bound - edge_falloff
						upper_curve = lower_bound + edge_falloff

					alpha = __CURVE((control_value - lower_curve) / (upper_curve - lower_curve))

					return __LINEAR_INTERP(source.get2(x, y), source2.get2(x, y), alpha)

				else if(control_value < (upper_bound - edge_falloff))
					return source2.get2(x, y)

				else if(control_value < (upper_bound + edge_falloff))
					var
						lower_curve = upper_bound - edge_falloff
						upper_curve = upper_bound + edge_falloff

					alpha = __CURVE((control_value - lower_curve) / (upper_curve - lower_curve))

					return __LINEAR_INTERP(source2.get2(x, y), source.get2(x, y), alpha)

				else
					return source.get2(x, y)

			else
				if(control_value < lower_bound || control_value > upper_bound)
					return source.get2(x, y)

				else
					return source2.get2(x, y)

		get3(x, y, z)
			x += seed
			y += seed
			z += seed

			var
				control_value = source3.get3(x, y, z)
				alpha

			if(edge_falloff > 0)
				if(control_value < (lower_bound - edge_falloff))
					return source.get3(x, y, z)

				else if(control_value < (lower_bound + edge_falloff))
					var
						lower_curve = lower_bound - edge_falloff
						upper_curve = lower_bound + edge_falloff

					alpha = __CURVE((control_value - lower_curve) / (upper_curve - lower_curve))

					return __LINEAR_INTERP(source.get3(x, y, z), source2.get3(x, y, z), alpha)

				else if(control_value < (upper_bound - edge_falloff))
					return source2.get3(x, y, z)

				else if(control_value < (upper_bound + edge_falloff))
					var
						lower_curve = upper_bound - edge_falloff
						upper_curve = upper_bound + edge_falloff

					alpha = __CURVE((control_value - lower_curve) / (upper_curve - lower_curve))

					return __LINEAR_INTERP(source2.get3(x, y, z), source.get3(x, y, z), alpha)

				else
					return source.get3(x, y, z)

			else
				if(control_value < lower_bound || control_value > upper_bound)
					return source.get3(x, y, z)

				else
					return source2.get3(x, y, z)