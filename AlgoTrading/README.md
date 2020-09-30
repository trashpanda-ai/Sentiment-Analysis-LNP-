# Algo Trading 101 

This is a comprehensible Introduction to Algo Trading for the members of TU I, to raise curiosity and resurrect Alternative Strategies/Assets.
The objective is a comprehensive overview in three lectures including 
- Data Collection, Preparation and Manipulation, 
- Model Selection and 
- Backtesting.

*To limit our time spent per section, basics in Python and Statistics are welcomed. If not, there will be links to a Backup Section with additional code and explanations.*

## Contents


<h1>Table of contents</h1>

<div class="alert alert-block alert-info" style="text-decoration:none; margin-top: 30px; background-color:#F2F2F2; border-color:#022F73">
    <span style="color:#022F73">
    <ol>
      <li><a href="#1"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Intro  </span> </a></li>
          <ol>
      <li><a href="#2"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >A comprehensive Overview  </span> </a></li>
      <li><a href="#2"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Definition of AlgoTrading  </span> </a></li>
      <li><a href="#3"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Benefits of an algorithmic approach</span> </a></li>
      <li><a href="#4"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Our Focus and Scope</span> </a></li>
        </ol>
      <li><a href="#5"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Raw Data </span> </a></li>
       <ol>
       <li><a href="#6"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Provider and APIs </span> </a></li>
       <li><a href="#7"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Let's limit our universe: What Markets and Instruments are fit for the start </span> </a></li>
       <li><a href="#6"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Data Snooping: p-Hacking, SVD and PCA </span> </a></li>
       </ol>   
       <li><a href="#8"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Preferred Statistical Characteristics of Data</span> </a></li>
       <ol>
       <li><a href="#9"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Skewness and Kurtosis</span> </a></li>
       <li><a href="#10"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Stationarity </span> </a></li>    
       <li><a href="#11"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Integration</span> </a></li>
       <li><a href="#12"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Cointegration </span> </a></li>     
       <li><a href="#19"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Todays Objective: processed dataset for our next lecture as feather pd </span> </a></li>
       </ol>
       <li><a href="#13"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >The two Basic Strategies as Foundation</span> </a></li> 
       <ol>
       <li><a href="#17"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Trend Based: Mean Reversion and Momentum</span> </a></li>
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Pairs Trading</span> </a></li>    
       </ol>   
       <li><a href="#13"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Advanced Manipulation to gain an Edge</span> </a></li> 
       <ol>
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Augmented-Dickey Fuller </span> </a></li> 
       <li><a href="#16"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Hurst Exponents </span> </a></li>
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Ornstein-Uhlenbeck </span> </a></li>
       <li><a href="#15"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Kalman Filter </span> </a></li>    
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Haar Transformation </span> </a></li>
       <li><a href="#17"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Exponential Smoothing </span> </a></li> 
       </ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Artificial Intelligence</span> </a></li>
       <ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Deep Neural Networks (DNN)</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Gradient-Boosted-Trees (GBT)</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Random Forests (RAF)</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Reinforcement Learning (RL)</span> </a></li>
       </ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Positions</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Thresholds for Entry and Exit</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Position Sizing</span> </a></li>
       </ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Backtesting</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Libraries</span> </a></li>   
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Biases: Look-Ahead, Survivorship and Overfitting</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Transaction Costs</span> </a></li>      
        </ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Performance</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Returns, Risk and Drawdown</span> </a></li>   
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Beta Hedging</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Portfolio Overview</span> </a></li>      
        </ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Portfolio Strategy</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Money Management</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Markowitz</span> </a></li>      
        </ol> 
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >APPENDIX</span> </a></li>
        <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Outlook for Part II: Derivatives, Big Data and Sentiment Analysis</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Additional Sources</span> </a></li> 
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Statistics 101</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Python 101</span> </a></li> 
        </ol>
    </ol>
    </span>
</div>