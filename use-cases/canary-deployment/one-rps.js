import http from 'k6/http';

export const options = {
    scenarios: {
        constant_request_rate: {
            executor: 'constant-arrival-rate',
            rate: 1,
            timeUnit: '1s', // 1000 iterations per second, i.e. 1000 RPS
            duration: '30m',
            preAllocatedVUs: 10, // how large the initial pool of VUs would be
            maxVUs: 200, // if the preAllocatedVUs are not enough, we can initialize more
        },
    },
};

export default function () {
    http.get('https://usecase.anthos.gcp-demo.be-svc.at');
}
