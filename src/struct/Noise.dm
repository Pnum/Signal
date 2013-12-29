Noise
	var
		seed = 0
		list/sources = list()
		Noise/source = null
		source_count_req = 0

	New(Noise/_source)
		if(_source) addSource(_source)

	proc
		setSources(list/_sources)
			ASSERT(length(_sources) <= source_count_req || (source_count_req < 0))
			sources = _sources

		setSource(Noise/_source)
			source = _source
			if(length(sources))
				sources[1] = source

		addSource(Noise/_source)
			ASSERT(length(sources) < source_count_req || (source_count_req < 0))
			sources += _source

			if(length(sources) == 1)
				source = sources[1]

		overrideSource(n, Noise/_source)
			ASSERT(n > 0)
			sources[n] = _source

		clearSources()
			sources = list()
			source = null

		removeSource(Noise/_source)
			sources -= _source

			if(source == _source) source = null

		setSeed(_seed)
			if(seed < __MIN_VALUE) seed = __MIN_VALUE
			if(seed > __MAX_VALUE) seed = __MAX_VALUE
			seed = round(_seed)

		randSeed()
			setSeed(rand(__MIN_VALUE, __MAX_VALUE))

		getSeed()
			return seed

		getSource()
			return source

		getSources()
			return sources

		getSourceCountReq()
			return source_count_req

		get2(x, y)

		get3(x, y, z)