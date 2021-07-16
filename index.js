
var axios = require('axios')

// Bases pour d'autres PRs
const exclusions = [
  'feature/garantie-jeune',
]
axios.get('https://api.github.com/repos/openfisca/openfisca-france/pulls')
.then(response => response.data)
.then(allPulls => allPulls/*.filter(p => !p.draft)*/.filter(p => p.labels.filter(l => l.name == 'aides-jeunes').length).filter(p => !exclusions.includes(p.head.ref)))
.then(relevantPulls => {
  relevantPulls.sort(function(a, b) {
    return a.number - b.number
  })
  return relevantPulls.map(p => p.head.ref)
})
.then(pulls => console.log(pulls.join('\n')))
