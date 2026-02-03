
  import http from 'k6/http';
  import { check, sleep } from 'k6';

  export const options = {
      stages: [
          // 1단계: 30명 (워밍업)
          { duration: '1m', target: 30 },
          { duration: '3m', target: 30 },

          // 2단계: 100명 (스케일 아웃 시작)
          { duration: '1m', target: 100 },
          { duration: '5m', target: 100 },  // 5분 유지

          // 3단계: 200명
          { duration: '1m', target: 200 },
          { duration: '5m', target: 200 },  // 5분 유지

          // 4단계: 400명
          { duration: '1m', target: 400 },
          { duration: '5m', target: 400 },  // 5분 유지

          // 5단계: 600명
          { duration: '1m', target: 600 },
          { duration: '5m', target: 600 },  // 5분 유지

          // 6단계: 800명 (한계 테스트)
          { duration: '1m', target: 800 },
          { duration: '5m', target: 800 },  // 5분 유지

          // 종료
          { duration: '2m', target: 0 },
      ],
      thresholds: {
          http_req_duration: ['p(95)<3000'],
          http_req_failed: ['rate<0.10'],
      },
  };

  const BASE_URL = 'https://www.shinhan6th.com';
  const productIds = [40, 41, 42, 43, 44];

  export default function () {
      let res1 = http.get(`${BASE_URL}/`);
      check(res1, { '메인 200': (r) => r.status === 200 });
      sleep(0.5);

      let productId = productIds[Math.floor(Math.random() * productIds.length)];
      let res2 = http.get(`${BASE_URL}/trade/${productId}`);
      check(res2, { '상품상세 200': (r) => r.status === 200 });
      sleep(0.5);

      let res3 = http.get(`${BASE_URL}/health`);
      check(res3, { '헬스 200': (r) => r.status === 200 });
      sleep(0.5);
  }
