import axios from 'axios';
import { TOKEN_BEGIN } from '../constants/tokenBegin';

// Utility function to get the API base URL
const getApiBaseUrl = () => {
    const envBaseUrl = process.env.REACT_APP_API_BASE_URL?.trim();
    return envBaseUrl || 'http://localhost:8080/';
};
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
