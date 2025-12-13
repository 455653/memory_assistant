package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.Flashcard;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDate;
import java.util.List;

/**
 * 闪卡 Mapper 接口
 */
public interface FlashcardMapper {
    
    /**
     * 根据ID查询卡片
     */
    Flashcard selectById(Long id);
    
    /**
     * 查询到期需要复习的卡片
     * @param userId 用户ID
     * @param today 今天日期
     * @return 到期卡片列表
     */
    List<Flashcard> selectDueCards(@Param("userId") Long userId, @Param("today") LocalDate today);
    
    /**
     * 查询用户的所有卡片
     */
    List<Flashcard> selectByUserId(Long userId);
    
    /**
     * 根据卡组ID查询卡片
     */
    List<Flashcard> selectByDeckId(Long deckId);
    
    /**
     * 插入卡片
     */
    int insert(Flashcard flashcard);
    
    /**
     * 更新卡片
     */
    int update(Flashcard flashcard);
    
    /**
     * 删除卡片
     */
    int deleteById(Long id);
}
