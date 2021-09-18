/* (BuildContext context, int i) {
              return ExpansionTile(
                title: Text('New recoding ${widget.records.length - i}'),
                subtitle: Text(_getDateFromFilePatah(
                    filePath: widget.records.elementAt(i))),
                onExpansionChanged: ((newState) {
                  if (newState) {
                    setState(() {
                      _selectedIndex = i;
                    });
                  }
                }),
                children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          minHeight: 5,
                          backgroundColor: Colors.black,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                          value: _selectedIndex == i ? _completedPercentage : 0,
                        ),
                        IconButton(
                          icon: _selectedIndex == i
                              ? _isPlaying
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow)
                              : Icon(Icons.play_arrow),
                          onPressed: () => _onPlay(
                              filePath: widget.records.elementAt(i), index: i),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } */