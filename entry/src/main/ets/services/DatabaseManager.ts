
import { punch_event_name } from '../constants';
import { NewTaskType } from '../types';
import distributedKVStore from '@ohos.data.distributedKVStore';
import { BusinessError } from '@kit.BasicServicesKit';

/*
 * 将来如果appstorage有改变存储介质和api可以统一管理
 * */
class DatabaseManager {

  getKvStore(): Promise<distributedKVStore.SingleKVStore | Error> {
    return new Promise((resolve, reject) => {
      try {
        const kvManager: distributedKVStore.KVManager = globalThis.kvManager;
        const options: distributedKVStore.Options = {
          createIfMissing: true, // 当数据库文件不存在时是否创建数据库，默认创建
          encrypt: false, // 设置数据库文件是否加密，默认不加密
          backup: false, // 设置数据库文件是否备份，默认备份
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION, // 设置要创建的数据库类型，默认为多设备协同数据库
          securityLevel: distributedKVStore.SecurityLevel.S2 // 设置数据库安全级别
        };
        kvManager.getKVStore<distributedKVStore.SingleKVStore>('mylocalDb', options).then(async (store: distributedKVStore.SingleKVStore | null) => {
          console.info('Succeeded in getting KVStore - safety save');
          globalThis.kvStore = store;
          resolve(store);
        })
      } catch (e) {
        console.error("get kv store failed")
        let error = e as BusinessError;
        reject(error);
      }
    })
  }

  async get(key): Promise<string> {
    return new Promise( async (resolve) => {
      let kvStore = globalThis.kvStore;
      if (!globalThis.kvStore) {
        kvStore = await this.getKvStore();
      };
      kvStore.get(key).then((data) => {
        resolve(data);
        console.error(`success get data`);
      }).catch((err) => {
        resolve("");
        console.error(`Failed to get.code is ${err.code},message is ${err.message}`);
      });
    })
  }

  async setOrCreate(key, data: string) {
    let kvStore = globalThis.kvStore;
    if (!globalThis.kvStore) {
      kvStore = await this.getKvStore();
    };
    kvStore.get(key, (err, _data) => {
      if (err !== undefined || !_data) {
        console.error(`{setOrCreate}-Failed to get data. Code:${err.code},message:${err.message}`);
        kvStore.put(key, data, (err, _d) => {
          if (err !== undefined) {
            console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
            return;
          }
          console.error("success put data");
        })
      }
    })
  }

  async delete(key) {
    let kvStore = globalThis.kvStore;
    if (!globalThis.kvStore) {
      kvStore = await this.getKvStore();
    };
    kvStore.delete(key, function (err) {
      if (err != undefined) {
        console.error(`Failed to delete.code is ${err.code},message is ${err.message}`);
        return;
      }
      console.info('Succeeded in deleting');
    });
  }

  async set(key, data: any) {
    let kvStore = globalThis.kvStore;
    if (!globalThis.kvStore) {
      kvStore = await this.getKvStore();
    };
    kvStore.put(key, data, (err, data) => {
      if (err !== undefined) {
        console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
        return;
      }
    })
  }

  async getAllPunchInData(): Promise<NewTaskType[] > {
    try {
      const getPunchInList = await this.get(punch_event_name.PUNCH_IN_ALL_DATA);
      if (getPunchInList !== '') {
        return JSON.parse(getPunchInList || "{}");
      } else {
        return [];
      }
    } catch (err) {
      console.error(`Failed to getAllPunchInData. Code:${err.code},message:${err.message}`);
      return [];
    }
  }


  // async getCurrentPunchIn(id) {
  //   try {
  //     const getPunchInList = await this.get(punch_event_name.PUNCH_IN_ALL_DATA);
  //     if (getPunchInList !== '') {
  //       return JSON.parse(getPunchInList || "{}");
  //     } else {
  //       return [];
  //     }
  //   } catch (err) {
  //     console.error(`Failed to getAllPunchInData. Code:${err.code},message:${err.message}`);
  //     return [];
  //   }
  // }
}

export default new DatabaseManager();