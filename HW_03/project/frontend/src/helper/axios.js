import axios from 'axios';
import { TOKEN_BEGIN } from '../constants/tokenBegin';

let REACT_APP_API_BASE_URL = '/api';
if (process.env.REACT_APP_API_BASE_URL !== undefined) {
    REACT_APP_API_BASE_URL = process.env.REACT_APP_API_BASE_URL.trim();
}

// Create Axios instance with the base URL
const instance = axios.create({
    baseURL: getApiBaseUrl(),
});

// Attach authorization token if available
const token = localStorage.getItem('token');
if (token?.includes(TOKEN_BEGIN)) {
    instance.defaults.headers.common.Authorization = token;
}

export default instance;
