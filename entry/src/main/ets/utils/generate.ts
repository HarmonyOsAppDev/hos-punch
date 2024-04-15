import cryptoFramework from '@ohos.security.cryptoFramework';

const urlAlphabet = 'useandom-26T198340PX75pxJACKVERYMINDBUSHWOLF_GQZbfghjklqvwyzrict';

const rand = cryptoFramework.createRandom();

export const getRandomId = (size: number): Promise<Array<number>> => {
  return new Promise((resolve, reject) => {
    rand.generateRandom(size).then(randData => {
      resolve(Object.values(randData.data));
    }).catch(error => {
      // 兜底
      console.error(`getRandomId Func Error: ${JSON.stringify(error)}`)
      reject(new Uint8Array(new Array(21)));
    });
  })
}

export const generateNanoId = async (size = 21) => {
    let id = ''
    const bytes = await getRandomId(size);
    while (size--) {
      id += urlAlphabet[bytes[size] & 63]
    }
    return id;
}

export const generateNanoIdSync = (size = 21) => {
  let id = ''
  const bytes = Object.values(rand.generateRandomSync(size)?.data);
  while (size--) {
    id += urlAlphabet[bytes[size] & 63]
  }
  return id;
}