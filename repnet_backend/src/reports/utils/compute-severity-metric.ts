export default (metricType, metrics) => {
  const scores = metrics.map((metric) => (
    metric[metricType][`${metricType}Score`]
  ));

  const maxScore = Math.max(...scores);

  const bonusFactor = 0.2;

  const remainingScore = scores.filter((score) => { 
    return score !== maxScore;
  }).reduce((accum, score) => { 
    return accum + score;
  }, 0);

  return maxScore + bonusFactor * remainingScore;
}