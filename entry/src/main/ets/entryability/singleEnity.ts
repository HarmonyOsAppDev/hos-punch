
import resmgr from '@ohos.resourceManager';

export class SingleEntity {
  private static instance: SingleEntity | null = null;
  private resourceManager: resmgr.ResourceManager;

  private constructor() {
    this.resourceManager = undefined;
  }

  setResourceManager(instance) {
    this.resourceManager = instance;
  }

  getResourceManager() {
    return this.resourceManager;
  }

  static getInstance(): SingleEntity {
    if (!SingleEntity.instance) {
      SingleEntity.instance = new SingleEntity();
    }
    return SingleEntity.instance;
  }
}

