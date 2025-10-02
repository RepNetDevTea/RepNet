const getMetricSection = (type, metrics) => {
  return metrics.map(({ metric }) => {
    return `
      Tag: ${metric[`${type}Name`]}\n
      \tSeverity score: ${metric[`${type}Score`]}\n
      \tDescription: ${metric[`${type}Description`]}`;
  }).join('\n\n');
};

export default (context) => {
  const { 
    tags, 
    impacts, 
    tagScoreData, 
    impactScoreData,
    evidenceFiles, 
  } = context;

  const tagsSection = getMetricSection('tag', tags);
  const impactsSection = getMetricSection('impact', impacts);

  const { tagWeight, tagsScore, realTagScore, } = tagScoreData;
  const { impactWeight, impactsScore, realImpactScore, } = impactScoreData;

  const inputText =  `
    Context Information:

    The user provided the following URL related to the incident:
    ${context.reportUrl}

    Here are the tags selected by the user. Each tag has a base severity 
    score and a short description:

    ${tagsSection}

    Here is the user’s description of the incident: 
    ${context.reportDescription}

    Here are the impacts reported by the user, representing what happened 
    to them:

    ${impactsSection}

    System Algorithm (already applied):

    Tags were scored as: ${tagWeight} * ${tagsScore} = ${realTagScore}.

    Impacts were scored as: ${impactWeight} * ${impactsScore} = ${realImpactScore}.

    A bonus factor was applied (+0.2) per additional tag or impact beyond the first.

    These scores represent the structured severity contribution of tags and impacts.

    Your Role – Evidence Severity:

    You are given the evidence files (images, screenshots, or other attachments) that 
    the user submitted. Your job is to evaluate how credible and strong this evidence 
    is, and classify it into one of three categories:

    Low (10): Weak, irrelevant, or inconclusive evidence.

    Medium (40): Clear and relevant evidence that supports the report, but not extremely 
    severe by itself.

    High (70): Strong, credible evidence showing direct malicious activity or high damage 
    potential (e.g., working phishing site, active malware sample, confirmed identity theft proof).

    Final Task:
    Return only the evidence severity score (10, 40, or 70) according to your expert 
    judgment. Do not recalculate tags or impacts—they are already computed by the system. 
    Your assessment should focus strictly on the evidences provided.
  `;

  return {
    messages: [
      {
        role: 'user',
        content: [
          { type: 'text', text: inputText },
          ...evidenceFiles
        ]
      }
    ]
  }
}