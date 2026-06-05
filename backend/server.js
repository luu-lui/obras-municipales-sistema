require('dotenv').config();

const express = require('express');
const cors = require('cors');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');

const authRoutes = require('./routes/authRoutes');
const contratistasRoutes = require('./routes/contratistasRoutes');
const supervisoresRoutes = require('./routes/supervisoresRoutes');
const obrasRoutes = require('./routes/obrasRoutes');
const avancesRoutes = require('./routes/avancesRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

require('./config/db');

app.use(cors());
app.use(express.json());

app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  explorer: true,
  swaggerOptions: {
    supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
    persistAuthorization: true
  }
}));

app.use('/api/auth', authRoutes);
app.use('/api/contratistas', contratistasRoutes);
app.use('/api/supervisores', supervisoresRoutes);
app.use('/api/obras', obrasRoutes);
app.use('/api/avances', avancesRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', sistema: 'Control de Obras Municipales' });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint no encontrado' });
});

app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
  console.log(`Swagger en http://localhost:${PORT}/docs`);
});