const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'API Control de Obras Municipales',
      version: '1.0.0',
      description: 'API REST para gestionar contratistas, supervisores, obras y avances'
    },
    servers: [
      {
        url: 'http://localhost:3000'
      }
    ]
  },
  apis: ['./routes/*.js']
};

module.exports = swaggerJsdoc(options);