
import resmgr from '@ohos.resourceManager';
import relationalStore from '@ohos.data.relationalStore';

export class SingleEntity {
  private static instance: SingleEntity | null = null;
  private resourceManager: resmgr.ResourceManager;
  private dbStore: relationalStore.RdbStore;

  private constructor() {
    this.resourceManager = undefined;
    this.dbStore = undefined;
  }

  setResourceManager(instance) {
    this.resourceManager = instance;
  }

  getResourceManager() {
    return this.resourceManager;
  }

  getDbStore() {
    return this.dbStore;
  }

  setDbStore(instance) {
    this.dbStore = instance;
  }

  static getInstance(): SingleEntity {
    if (!SingleEntity.instance) {
      SingleEntity.instance = new SingleEntity();
    }
    return SingleEntity.instance;
  }
}

