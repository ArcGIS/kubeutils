/* Copyright (c) 2018 Environmental Systems Research Institute, Inc.
 * Apache-2.0 */

const { loadEnvironment } = require('./lib')
const { loadResources, kubectl } = require('../')

async function execute (options) {
  const environment = loadEnvironment(options.env)
  const resources = await loadResources('k8s', { ...environment, ...options })

  const deployments = resources
    .filter(r => {
      return r.kind === 'Deployment'
    })
    .map(d => {
      return d.metadata.name
    })

  console.log('rolling back deployments')
  await Promise.all(
    deployments.map(d => {
      return kubectl.rollout(d, 'undo', { namespace: options.env })
    })
  )
}

module.exports = execute
