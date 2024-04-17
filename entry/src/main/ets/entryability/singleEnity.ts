
import resmgr from '@ohos.resourceManager';
import { TomatoSettingInputKey, TomatoTaskItem, TomatoTaskType } from '../types';

export class SingleEntity {
  private static instance: SingleEntity | null = null;
  private resourceManager: resmgr.ResourceManager;
  private tomatoSetting: TomatoTaskItem[];

  private constructor() {
    this.resourceManager = undefined;
  }

  setResourceManager(instance) {
    this.resourceManager = instance;
  }

  getResourceManager() {
    return this.resourceManager;
  }

  getTomatoSetting(data: TomatoSettingInputKey) {
    return this.tomatoSetting;
  }

  setTomatoSetting(task: TomatoSettingInputKey) {
    const allTask: TomatoTaskItem[] = [];
    const fillTask: string[] = new Array(task.count).fill('');

    fillTask.forEach((_: string, index: number) => {
      allTask.push({
        minute: task.every_time_len,
        type: TomatoTaskType.PROCESS,
        tomato_current: index + 1
      })
      if (index !== fillTask.length - 1) {
        allTask.push({
          minute: task.rest_time_len,
          type: TomatoTaskType.REST,
          tomato_current: index + 1
        })
      }
    });
    this.tomatoSetting = allTask;
  }

  static getInstance(): SingleEntity {
    if (!SingleEntity.instance) {
      SingleEntity.instance = new SingleEntity();
    }
    return SingleEntity.instance;
  }
}

