import jsonFile "./example.json" with { type: 'json' };

const ConversionUnixTimeStamp = (unixtimestamp13: number) => {
  const dateInstance = new Date(unixtimestamp13)
  return {
    date: dateInstance.toLocaleDateString()
    , time24: dateInstance.toLocaleTimeString()
    , time12: dateInstance.toLocaleTimeString('en-US')
    , millisecond: dateInstance.getTime().toString().slice(-3)
  }
}

Object.values(jsonFile).forEach((value) => {
  console.log(value)
});
